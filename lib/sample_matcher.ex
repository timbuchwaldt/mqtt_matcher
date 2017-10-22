defmodule SampleMatcher do
  use MQTTMatcher

  match "argsandpayload", payload, args do
    {:argsandplayload, payload, args}
  end

  match "+", payload, _args do
    :single_wildcard
  end

  match "+foo/+_bar/+_baz", "payload", _args do
    {:wildcard, foo}
  end

  match "+_/baz", payload, _args do
    :ignored_wildcard
  end

  match "rest/#", payload, _args do
    {:rest, rest}
  end

  match "#", payload, _args do
    {:full_rest, rest}
  end
end
