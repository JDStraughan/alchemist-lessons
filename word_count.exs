filename = IO.gets("File to count words: ") |> String.trim
body = File.read!(filename) |> String.split()
IO.inspect body
