defmodule MQTTMatcher do
  defmacro __using__(_) do
    quote do
      import MQTTMatcher

      def match(path, payload, args \\ nil) do
        path
        |> String.split("/")
        |> int_mqtt_match(payload, args)
      end
    end
  end

  defmacro match("/" <> _, _) do
    raise "MQTT Topics with a leading slash are forbidden"
  end

  defmacro match(topic, payload, args, do: block) do
    split =
      String.split(topic, "/")
      |> Enum.map(&map/1)
      |> Enum.filter(fn item -> item != nil end)

    if count_hash(topic) > 1 do
      raise "MQTT topics can only contain one '#'"
    end

    if String.contains?(topic, "#") and not(topic == "#" or String.ends_with?(topic, "/#")) do
      raise "MQTT topics can only contain '/#' at the end or be '#'"
    end

    # due to matching rests as [a,b,c | rest] we need to differentiate between 3 cases
    cond do
      # exactly a "#""
      topic == "#" ->
        quote do
          defp int_mqtt_match(var!(rest), unquote(payload), unquote(args)) do
            unquote(block)
          end
        end

      # ending with a "#"
      String.ends_with?(topic, "#") ->
        quote do
          defp int_mqtt_match(
                 [unquote_splicing(split) | var!(rest)],
                 unquote(payload),
                 unquote(args)
               ) do
            unquote(block)
          end
        end

      # or not containing any "#"
      true ->
        quote do
          defp int_mqtt_match(unquote(split), unquote(payload), unquote(args)) do
            unquote(block)
          end
        end
    end
  end

  defp map("+") do
    # simple "+" in the path are ignored in the function definition
    quote do: _
  end

  defp map("+" <> identifier) do
    # "+name" is transferred to a variable called "name"
    unless valid_variable_name?(identifier) do
      raise "Invalid variable name defined: #{identifier}"
    end

    # creates a variable of the name "identifier"
    id =
      identifier
      |> String.to_atom()
      |> Macro.var(__MODULE__)

    quote do: var!(unquote(id))
  end

  # hashes are ignored, they can't be matched in the list
  defp map("#"), do: nil

  # remaining strings are used as is
  defp map(str), do: str

  defp valid_variable_name?(candidate), do: Regex.match?(~r/^_?[a-z]*$/, candidate)

  defp count_hash(input) do
    input
    |> String.split("")
    |> Enum.reduce(0, fn char, acc -> if char == "#", do: acc + 1, else: acc end)
  end
end
