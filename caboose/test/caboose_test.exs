defmodule CabooseTest do
  use ExUnit.Case
  doctest Caboose

  test "greets the world" do
    assert Caboose.hello() == :world
  end
end
