defmodule AdvancedScoreTrackerTest do
  use ExUnit.Case
  doctest AdvancedScoreTracker

  test "add/3 should be able to add new player game score" do
    AdvancedScoreTracker.start_link()
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    assert 20 = AdvancedScoreTracker.get(:player1, :ping_pong)
  end

  test "new/2 should be able to start a new point total with a default score of 0" do
    AdvancedScoreTracker.start_link()
    AdvancedScoreTracker.new(:player1, :ping_pong)
    assert 0 = AdvancedScoreTracker.get(:player1, :ping_pong)
  end

  test "new/2 should be able to save history" do
    AdvancedScoreTracker.start_link()
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.new(:player1, :ping_pong)
    assert [0, 20] = AdvancedScoreTracker.history(:player1, :ping_pong)
  end



  test "high_score/2 should be able to find a player's highest score from their history" do
    AdvancedScoreTracker.start_link()
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.new(:player1, :ping_pong)
    assert 20 = AdvancedScoreTracker.high_score(:player1, :ping_pong)
  end

  test "high_score/1 should be able to find the highest score out of all players for a game" do
    AdvancedScoreTracker.start_link()
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.add(:player1, :ping_pong, 10)
    AdvancedScoreTracker.new(:player1, :ping_pong)
    AdvancedScoreTracker.add(:player2, :ping_pong, 10)
    AdvancedScoreTracker.new(:player2, :ping_pong)
    assert 20 = AdvancedScoreTracker.high_score(:ping_pong)
  end
end
