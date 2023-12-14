defmodule Games.RockPaperScissors do
  @moduledoc """
   Documentation for `Games.RockPaperScissors`.
  """
  @type option :: String.t()

  @spec play() :: String.t()
  def play() do
    valid_options = ["rock", "paper", "scissors"]
    machine_hand = Enum.random(valid_options)
    user_hand = IO.gets("Choose rock, paper, or scissors: ") |> String.trim()

    case {user_hand, machine_hand} do
      {"rock", "scissors"} -> "You win! rock beats scissors."
      {"paper", "rock"} -> "You win! paper beats rock."
      {"scissors", "paper"} -> "You win! scissors beats paper."
      {"rock", "paper"} -> "You lose! paper beats rock."
      {"paper", "scissors"} -> "You lose! scissors beats paper."
      {"scissors", "rock"} -> "You lose! rock beats scissors."
      _ -> "It's a tie!"
    end
  end
end