defmodule SampleMatcher do
  use MQTTMatcher

  mqtt_match "+" do
    :single_wildcard
  end

  mqtt_match "+foo/+_bar/+_baz" do
    {:wildcard, foo}
  end

  mqtt_match "+_/baz" do
    :ignored_wildcard
  end

  mqtt_match "rest/#" do
    {:rest, rest}
  end

  mqtt_match "#" do
    {:full_rest, rest}
  end
end
