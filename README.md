# MQTTMatcher

MQTTMatcher allows for defining functions to match MQTT topics.

It turns

```elixir
use MQTTMatcher
match "a/+b/#", payload, _args do
  IO.inspect(b)
  IO.inspect(rest)
end
```

into this:

```elixir
def match(path, payload, args \\ nil) do
  path
  |> String.split("/")
  |> int_mqtt_match(args)
end

defp int_mqtt_match(["a", b|rest], payload, args) do
  IO.inspect(b)
  IO.inspect(rest)
end
```

The variables defined in the MQTT topic with a beginning + are turned into Elixir variables,
the '#' is turned into a tail matching list. All matches are defined as private functions and a wrapper function
is created to call those functions, splitting the input MQTT topic and passing an argument list.

Arguments and the payload are passed right through and can be used for pattern matching as well.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mqtt_matcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mqtt_matcher, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mqtt_matcher](https://hexdocs.pm/mqtt_matcher).

