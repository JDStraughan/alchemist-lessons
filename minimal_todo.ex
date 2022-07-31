defmodule MinimalTodo do
  def start do
    input = IO.gets("Create a new list? (y/n)? ")
      |> String.trim()
      |> String.downcase()
    if input == "y" do
      create_initial_todo() |> get_command()
    else
      load_csv()
    end
  end

  def create_initial_todo() do
    first_todo = IO.gets("What is our first item on the list?\n")
    Map.put(%{}, first_todo, %{
      "Date Added" => "Dec 31",
      "Notes" => "Notes go here",
      "Priority" => "0",
      "Urgency" => "0"
    })
  end

  def load_csv() do
    filename = IO.gets("Name of .csv file to load: ") |> String.trim
    read(filename)
      |> parse()
      |> get_command()
  end

  def get_command(data) do
    prompt = "Type the first letter of the command you want to execute\n"
    <> "[R]ead Todos  [A]dd Todo  [D]elete Todo [L]oad CSV  [S]ave CSV [Q]uit\n"

    command = IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

      case command do
        "r" -> show_todos(data)
        "a" -> add_todo(data)
        "d" -> delete_todo(data)
        "s" -> save(data)
        "l" -> load_csv()
        "q" -> "Goodbye!"
        _   -> get_command(data)
      end
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body}       -> body
      {:error, reason}  -> IO.puts ~s(Could not open file '#{filename}')
                           IO.puts ~s(Error: #{:file.format_error reason})
                           start()
    end
  end

  def save(data) do
    prepare_csv(data)
      |> save_csv()
    get_command(data)
  end

  def save_csv(data) do
    filename = IO.gets("Name of .csv file to save: ") |> String.trim
    case File.write(filename, data) do
      :ok               -> IO.puts("CSV Saved")
      {:error, reason}  -> IO.puts ~s(Could not write file '#{filename}')
                           IO.puts ~s(Error: #{:file.format_error reason})
                           get_command(data)
    end
  end

  def prepare_csv(data) do
    headers = ["Item" | get_fields(data)]
    item_rows = Enum.map(Map.keys(data), fn item ->
      [item | Map.values(data[item])]
    end)
    [headers | item_rows]
      |> Enum.map(&(Enum.join(&1, ",")))
      |> Enum.join("\n")
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

  def add_todo(data) do
    todo = IO.gets("Enter todo to add:\n")
      |> String.trim()
    cond do
      Map.has_key?(data, todo) ->
        IO.puts("You already have that todo, remember?")
        add_todo(data)
      todo == "" ->
        IO.puts("You can't have empty todos!")
        add_todo(data)
      true ->
        new_list = Map.put(data, todo, %{
          "Date Added" => "Dec 31",
          "Notes" => "Notes go here",
          "Priority" => "0",
          "Urgency" => "0"
        })
        IO.puts("Added!\n")
        IO.puts("UPDATED Todos:\n")
        show_todos(new_list)
    end
  end

  def get_fields(data) do
    data[hd Map.keys data] |> Map.keys
  end

end
