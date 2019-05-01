defmodule ExeExampleTest do
  use ExUnit.Case
  doctest ExeExample

  test "greets the world" do
    assert ExeExample.hello() == :world
  end
end
