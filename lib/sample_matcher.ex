defmodule SampleMatcher do
  use MQTTMatcher

  match "+" do
    :single_wildcard
  end

  match "+foo/+_bar/+_baz" do
    {:wildcard, foo}
  end

  match "+_/baz" do
    :ignored_wildcard
  end

  match "rest/#" do
    {:rest, rest}
  end

  match "#" do
    {:full_rest, rest}
  end
end
