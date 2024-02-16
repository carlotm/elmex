defmodule ElmexTest do
  use ExUnit.Case
  doctest Elmex

  test "greets the world" do
    assert Elmex.hello() == :world
  end
end
