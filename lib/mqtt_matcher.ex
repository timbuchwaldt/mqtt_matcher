defmodule MQTTMatcher do
  defmacro __using__(_) do
    quote do
      import MQTTMatcher

      def mqtt_match(path, args \\ nil) do
        path
        |> String.split("/")
        |> int_mqtt_match(args)
      end
    end
  end

  defmacro mqtt_match("/" <> _, _) do
    raise "MQTT Topics with a leading slash are forbidden"
  end

  defmacro mqtt_match(string, do: block) do
    split =
      String.split(string, "/")
      |> Enum.map(&map/1)
      |> Enum.filter(fn item -> item != nil end)

    if count_hash(string) > 1 do
      raise "MQTT topics can only contain one '#'"
    end

    if String.contains?(string, "#") and not(string == "#" or String.ends_with?(string, "/#")) do
      raise "MQTT topics can only contain '/#' at the end or be '#'"
    end

    cond do
      string == "#" ->
        quote do
          defp int_mqtt_match(var!(rest), var!(args)) do
            unquote(block)
          end
        end

      String.ends_with?(string, "#") ->
        quote do
          defp int_mqtt_match([unquote_splicing(split) | var!(rest)], var!(args)) do
            unquote(block)
          end
        end

      true ->
        quote do
          defp int_mqtt_match(unquote(split), var!(args)) do
            unquote(block)
          end
        end
    end
  end

  defp map("+") do
    quote do: _
  end

  defp map("+" <> identifier) do
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

  defp map("#"), do: nil

  defp map(str), do: str

  defp valid_variable_name?(candidate), do: Regex.match?(~r/^_?[a-z]*$/, candidate)

  defp count_hash(input) do
    input
    |> String.split("")
    |> Enum.reduce(0, fn char, acc -> if char == "#", do: acc + 1, else: acc end)
  end
end
