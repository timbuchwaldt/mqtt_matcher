defmodule MQTTMatcherTest do
  use ExUnit.Case

  test "single wildcard" do
    assert SampleMatcher.match("foo", "payload") == :single_wildcard
  end

  test "multiple wildcards" do
    assert SampleMatcher.match("test/ignored_bar/ignored_baz", "payload") == {:wildcard, "test"}
  end

  test "ignored wildcards" do
    assert SampleMatcher.match("iamigored/baz", "payload") == :ignored_wildcard
  end

  test "rest" do
    assert SampleMatcher.match("rest/super/a/w/e/s/o/m/e", "payload") == {
             :rest,
             ["super", "a", "w", "e", "s", "o", "m", "e"]
           }
  end

  test "full rest" do
    assert SampleMatcher.match("fullrest/1/2/3/4/5", "payload") == {
             :full_rest,
             ["fullrest", "1", "2", "3", "4", "5"]
           }
  end

  test "arguments and payload" do
    assert SampleMatcher.match("argsandpayload", "payload", argument1: :one, argumenttwo: 2) == {
             :argsandplayload,
             "payload",
             [argument1: :one, argumenttwo: 2]
           }
  end
end
