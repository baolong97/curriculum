defmodule Games.ScoreTracker do
  @moduledoc """
  iex> {:ok, _pid} = Games.ScoreTracker.start_link([])
  iex> Games.ScoreTracker.add_points(10)
  :ok
  iex> Games.ScoreTracker.current_score()
  10
  """
  use GenServer

  # Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def add_points(amount) do
    GenServer.cast(__MODULE__, {:add_points, amount})
  end

  def current_score() do
    GenServer.call(__MODULE__, :current_score)
  end

  # Server API

  def init(_init_arg) do
    {:ok, 0}
  end

  def handle_cast({:add_points, amount}, state) do
    {:noreply, state + amount}
  end

  def handle_call(:current_score, _from, state) do
    {:reply, state, state}
  end
end
