defmodule Games.GuessingGame do
  defp hint(guess,answer) do
    if guess>answer do
      IO.puts("Too High!")
    else
      IO.puts("Too Low!")
    end
  end

  defp play(answer,attempts\\0) do
    {guess, _} = IO.gets("Guess a number between 1 and 10: ") |> Integer.parse()
    if guess == answer do
      "You win!"
    else
      if attempts == 5 do
        "You lose! the answer was #{answer}"
      else
        hint(guess,answer)
        play(answer,attempts+1)
      end
    end
  end

  def play() do
    answer = Enum.random(1..10)
    play(answer)
  end
end
