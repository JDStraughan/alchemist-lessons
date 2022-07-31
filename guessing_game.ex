defmodule GuessingGame do

  def guess(a, b) when a > b, do: guess(b, a)

  def guess(low, high) do
    answer = IO.gets("Is your number #{middle(low, high)}? ")
    case String.trim(answer) do
      "higher" -> higher(low, high)
      "lower" -> lower(low, high)
      "yes" -> "GOT IT!"
      _ -> "Please enter 'higher', 'lower', or 'yes'"
    end
  end

  def middle(low, high) do
    div(low + high, 2)
  end

  def higher(low, high) do
    new_low = min(high, middle(low, high) + 1)
    guess(new_low, high)
  end

  def lower(low, high) do
    new_high = max(low, middle(low, high) - 1)
    guess(low, new_high)
  end

end
