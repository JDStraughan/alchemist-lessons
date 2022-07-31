defmodule NameGame do

  def start do
    IO.gets("What is your NAME? ")
    |> String.trim()
    |> respond_to()
  end

  def respond_to name do
    case String.downcase(name) do
      "jason" -> IO.puts("That's my name, too! Have a Holy Grail, #{name}! WINNER!")
      name -> IO.puts("Hello #{name}, what is your QUEST?")
    end
  end

end
