defmodule WordCounterTest do
  use ExUnit.Case
  doctest WordCounter

  test "turns a list into a map of elements and occurances" do
    assert WordCounter.to_count_map([:a, 3, 1, :b, :a, 2, :a, :b]) ==
      %{:a => 3, 3 => 1, 1 => 1, :b => 2, 2 => 1}
  end

  test "turns a map into a list of tuples sorted by their values" do
    assert WordCounter.sort_by_val(%{:a => 3, 3 => 1, 1 => 1, :b => 2, 2 => 1}) ==
      [{:a, 3}, {:b, 2}, {1, 1}, {2, 1}, {3, 1}]
  end

  test "turns a list of tuples into a list of strings" do
    assert WordCounter.write_list([{"the", 10}, {"dog", 8}, {42, 3}]) ==
      ["the: 10\n", "dog: 8\n", "42: 3\n"]
  end

  test "turns a list of tuples into a list of strings with custom separator" do
    assert WordCounter.write_list([{"the", 10}, {"dog", 8}, {42, 3}], " = ") ==
      ["the = 10\n", "dog = 8\n", "42 = 3\n"]
  end

end
