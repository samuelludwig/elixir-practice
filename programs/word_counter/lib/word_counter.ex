defmodule WordCounter do
  @moduledoc """
  Counts the occurances of words in a given text file, and lists the occurances from most to least frequent
  The list of occurances will be written to `occurances.txt` and will listed in tuples `[{word, occurs}]`
  """

  @doc """
  get_words(file)
  Reads a file and returns a list of every single word in the file.
  All punctuation is removed, and all characters are converted to lowercase.

  ## Parameters

  - `file :: String.t`, the file to be read.

  """
  @spec get_words(String.t) :: [String.t]
  def get_words(file) do
    File.stream!(file)
    |> Enum.map(&String.replace(&1, ~r/[^a-zA-Z-' ]/, ""))
    |> Enum.map(&String.downcase(&1))
    |> Enum.map(&Regex.split(~r/ /, &1))
    |> List.flatten()
  end

  @doc """
  to_count_map(x)
  Counts occurances of each item in a list and returns it in a map of %{elem, occurances}

  ## Parameters

  - `x :: [any]`, the list to be processed.

  ## Examples

      iex> WordCounter.to_count_map([:a, 3, 1, :b, :a, 2, :a, :b])
      %{:a => 3, 3 => 1, 1 => 1, :b => 2, 2 => 1}

  """
  @spec to_count_map([any]) :: %{any => integer}
  def to_count_map(x) do
    x |> Enum.reduce(%{}, fn(y, acc) -> Map.update(acc, y, 1, &(&1 + 1)) end)
  end

  @doc """
  sort_by_val(x)
  Takes a map and transforms it into a list of tuples, sorted by the values of the map.

  ## Parameters

  - `x :: %{any, integer}`, the map to be processed.

  ## Examples

      iex> WordCounter.sort_by_val(%{:a => 3, 3 => 1, 1 => 1, :b => 2, 2 => 1})
      [{:a, 3}, {:b, 2}, {1, 1}, {2, 1}, {3, 1}]

  """
  @spec sort_by_val(%{any => integer}) :: [{any, integer}]
  def sort_by_val(x) do
    x |> Map.to_list() |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
  
  @doc ~S"""
  write_list(x, separator \\ ": ")
  Takes a list of two-value tuples and returns them as a string, with each
  tuple separated by a newline.

  ## Parameters

  - `x :: [{any, integer}]`, the list to be written.
  - `separator :: String.t`, (Optional) the syntax that will separate the
  first and second values of each tuple when it is written;
  defaults to ": ".

  ## Examples

      iex> WordCounter.write_list([{"the", 10}, {"dog", 8}, {42, 3}])
      ["the: 10\n", "dog: 8\n", "42: 3\n"]

      iex> WordCounter.write_list([{"the", 10}, {"dog", 8}, {42, 3}], " = ")
      ["the = 10\n", "dog = 8\n", "42 = 3\n"]

  """
  @spec write_list([{any, any}], String.t) :: [String.t]
  def write_list(x, separator \\ ": ") do
    x |> Enum.map(&("#{elem(&1, 0)}" <> separator <> "#{elem(&1, 1)}\n"))
  end


  @doc """
  count_stream(from_file, to_file)
  Glue-function, takes contents of a text file (`from_file`), and writes into
  another text file (`to_file`) the occurances of each word used, ordered by
  occurances of the word, from most to least used.

  ## Parameters

  - `from_file :: String.t`, filepath to read from.
  - `to_file :: String.t`, filepath to write to.

  """
  @spec count_stream(String.t, String.t) :: atom
  def count_stream(from_file, to_file) do
    File.write(to_file,
    from_file
    |> get_words()
    |> to_count_map()
    |> sort_by_val()
    |> write_list())
  end

end
