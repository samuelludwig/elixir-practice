defmodule Choices do
  def main(args) do
    args |> parse_choices |> output
  end

  defp output(opts) do
    case opts[:choice] do
      "Blue" ->
        IO.puts "You pulled the blue lever. That is progressive."
      "Red" ->
        IO.puts "You pulled the red lever. That is conservative."
      _ ->
        IO.puts "You clearly want to waste your choice. That's ok, it's a free country."
    end
  end

  defp parse_choices(args) do
    {options, _, _} = OptionParser.parse(
      args, switches: [choice: :string]
    )
    options
  end

end
