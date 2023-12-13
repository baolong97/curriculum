defmodule GamesWordleTest do
  use ExUnit.Case
  doctest Games.Wordle

  test "all green" do
    assert Games.Wordle.feedback("AAAAA", "AAAAA") == [:green, :green, :green, :green, :green]
  end

  test "all yellow" do
    assert Games.Wordle.feedback("ABABAB", "BABABA") == [
             :yellow,
             :yellow,
             :yellow,
             :yellow,
             :yellow,
             :yellow
           ]
  end

  test "same letter is all 3 colors" do
    assert Games.Wordle.feedback("XXXAA", "AAAAY") == [:yellow, :grey, :grey, :green, :grey]
  end
end
