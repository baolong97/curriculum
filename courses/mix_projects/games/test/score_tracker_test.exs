defmodule ScoreTracker do
  use ExUnit.Case
  doctest Games.ScoreTracker

  test "current_score/1 retrieves the current score" do
    {:ok, _pid} = Games.ScoreTracker.start_link([])
    assert Games.ScoreTracker.current_score() == 0
  end

  test "add_points/1 adds points to the score" do
    {:ok, _pid} = Games.ScoreTracker.start_link([])
    Games.ScoreTracker.add_points(10)
    assert Games.ScoreTracker.current_score() == 10
  end
end
