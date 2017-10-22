defmodule MQTTMatcherTest do
  use ExUnit.Case

  test "single wildcard" do
    assert SampleMatcher.match("foo") == :single_wildcard
  end

  test "multiple wildcards" do
    assert SampleMatcher.match("test/ignored_bar/ignored_baz") == {:wildcard, "test"}
  end

  test "ignored wildcards" do
    assert SampleMatcher.match("iamigored/baz") == :ignored_wildcard
  end

  test "rest" do
    assert SampleMatcher.match("rest/super/a/w/e/s/o/m/e") == {
             :rest,
             ["super", "a", "w", "e", "s", "o", "m", "e"]
           }
  end

  test "full rest" do
    assert SampleMatcher.match("fullrest/1/2/3/4/5") == {
             :full_rest,
             ["fullrest", "1", "2", "3", "4", "5"]
           }
  end
end
