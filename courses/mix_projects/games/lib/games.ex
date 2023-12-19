defmodule Games do
  def loop("stop") do
    IO.puts("Goodbye!")
  end

  def loop("score") do
    IO.puts("""
    ====================================
      Your score is #{Games.ScoreTracker.current_score()}
    ====================================
    """)

    user_choice =
      IO.gets("""
      What game would you like to play?
      1. Guessing Game
      2. Rock Paper Scissors
      3. Wordle

      enter "stop" to exit
      enter "score" to view your current score
      """)
      |> String.trim()

    loop(user_choice)
  end

  def loop(user_choice) do
    case user_choice do
      "1" -> IO.puts(Games.GuessingGame.play())
      "2" -> IO.puts(Games.RockPaperScissors.play())
      "3" -> IO.puts(Games.Wordle.play())
    end

    user_choice =
      IO.gets("""
      What game would you like to play?
      1. Guessing Game
      2. Rock Paper Scissors
      3. Wordle

      enter "stop" to exit
      enter "score" to view your current score
      """)
      |> String.trim()

    loop(user_choice)
  end

  def main(_args) do
    {:ok, _pid} = Games.ScoreTracker.start_link([])

    user_choice =
      IO.gets("""
      What game would you like to play?
      1. Guessing Game
      2. Rock Paper Scissors
      3. Wordle

      enter "stop" to exit
      enter "score" to view your current score
      """)
      |> String.trim()

    loop(user_choice)
  end
end
