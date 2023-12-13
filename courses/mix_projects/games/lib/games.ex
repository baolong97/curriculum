defmodule Games do
  def main(args) do
    user_choice= IO.gets("""
    What game would you like to play?
    1. Guessing Game
    2. Rock Paper Scissors
    3. Wordle

    enter "stop" to exit
    """) |> String.trim()
    case user_choice do
      "1"->IO.puts(Games.GuessingGame.play())
      "2"->IO.puts(Games.RockPaperScissors.play())
      "3"->IO.puts(Games.Wordle.play())
      "stop" -> IO.puts("Goodbye!")
    end
  end
end
