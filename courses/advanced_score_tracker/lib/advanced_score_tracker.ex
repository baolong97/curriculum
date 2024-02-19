defmodule AdvancedScoreTracker do
  @moduledoc """
  Documentation for `AdvancedScoreTracker`.
  """

  use Agent

  @doc false
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc false
  def add(player, game, score) do
    Agent.update(__MODULE__, fn state ->
      case Map.get(state, player) do
        nil ->
          Map.put(state, player, %{game => %{scores: [score], history: []}})

        player_data ->
          case Map.get(player_data, game) do
            nil ->
              Map.put(state, player, Map.put(player_data, game, %{scores: [score], history: []}))

            game_data ->
              Map.put(
                state,
                player,
                Map.put(
                  player_data,
                  game,
                  Map.put(game_data, :scores, [score | game_data.scores])
                )
              )
          end
      end
    end)
  end

  @doc false
  def get(player, game) do
    Agent.get(__MODULE__, fn state ->
      case Map.get(state, player) do
        nil ->
          0

        player_data ->
          case Map.get(player_data, game) do
            nil ->
              0

            game_data ->
              Enum.sum(game_data.scores)
          end
      end
    end)
  end

  @doc false
  def new(player, game) do
    Agent.update(__MODULE__, fn state ->
      case Map.get(state, player) do
        nil ->
          Map.put(state, player, %{game => %{scores: [], history: []}})

        player_data ->
          case Map.get(player_data, game) do
            nil ->
              Map.put(state, player, Map.put(player_data, game, %{scores: [], history: []}))

            game_data ->
              history =
                if length(game_data.scores) > 0 do
                  [Enum.sum(game_data.scores) | game_data.history]
                else
                  game_data.history
                end

              Map.put(state, player, Map.put(player_data, game, %{scores: [], history: history}))
          end
      end
    end)
  end

  @doc false
  def history(player, game) do
    [
      get(player, game)
      | Agent.get(__MODULE__, fn state ->
          case Map.get(state, player) do
            nil ->
              []

            player_data ->
              case Map.get(player_data, game) do
                nil ->
                  []

                game_data ->
                  game_data.history
              end
          end
        end)
    ]
  end

  @doc false
  def high_score(player, game) do
    Enum.max(history(player, game))
  end

  @doc false
  def high_score(game) do
    Agent.get(__MODULE__, fn state ->
      Enum.reduce(Map.values(state), 0, fn player_data, max ->
        temp =
          case Map.get(player_data, game) do
            nil ->
              0

            game_data ->
              Enum.max([Enum.sum(game_data.scores) | game_data.history])
          end

        Enum.max([max | [temp]])
      end)
    end)
  end
end
