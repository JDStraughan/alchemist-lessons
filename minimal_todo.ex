defmodule MinimalTodo do
  def start do
    # ask user for filename
    filename = IO.gets("Name of .csv file to load: ") |> String.trim
    read(filename)
      |> parse()
      |> get_command()

    # add todos
    # load file
    # save file
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body}       -> body
      {:error, reason}  -> IO.puts ~s(Could not open file '#{filename}')
                           IO.puts ~s(Error: #{:file.format_error reason})
                           start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl String.split(header, ",")
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")
      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys data
    IO.puts "You gots some stuff todo:\n"
    Enum.each(items, fn item -> IO.puts(item) end)
    IO.puts("\n")
    if next_command? do
      get_command(data)
    end
  end

  def get_command(data) do
    prompt = "Type the first letter of the command you want to execute\n"
    <> "[R]ead Todos  [A]dd Todo  [D]elete Todo [L]oad CSV  [S]ave CSV\n"

    command = IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

      case command do
        "r"     -> show_todos(data)
        "d"     -> delete_todo(data)
        "q"     -> "Goodbye!"
        _       -> get_command(data)
      end
  end

  def delete_todo(data) do
    todo = IO.gets("Which todo to delete?\n")
      |> String.trim()
    if Map.has_key?(data, todo) do
      IO.puts("ok.")
      new = Map.drop(data, [todo])
      IO.puts("It's gone")
      get_command(new)
    else
      IO.puts(~s{There is no todo named "#{todo}"!})
      show_todos(data, false)
      delete_todo(data)
    end
  end

end
