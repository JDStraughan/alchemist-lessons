IO.gets("File to count words: ")
  |> String.trim
  |> File.read!
  |> String.split(~r{\\n|[^\w']+})
  |> Enum.filter(fn x -> x != "" end)
  |> Enum.count
  |> IO.puts
  |> IO.inspect
