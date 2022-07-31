defmodule WordCount.Cli do
  def main(args) do
    {parsed, args, invalid} = OptionParser.parse(
      args,
      switches: [chars: nil, lines: nil, words: nil],
      aliases: [c: :chars, l: :lines, w: :words])
    WordCount.start(parsed, args, invalid)
  end
end
