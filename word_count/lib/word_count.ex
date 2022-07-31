defmodule WordCount do
  def start(parsed, filename, invalid) do
    filename
      |> hd
      |> String.trim
      |> File.read!
      |> String.split(~r{\\n|[^\w']+})
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.count
      |> IO.puts
  end
end
