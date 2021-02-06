defmodule LiveStructTest do
  use ExUnit.Case
  doctest LiveStruct

  test "greets the world" do
    assert LiveStruct.hello() == :world
  end
end
