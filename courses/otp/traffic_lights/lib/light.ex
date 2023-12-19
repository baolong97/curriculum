defmodule TrafficLights.Light do
  use GenServer

  @impl true
  def init(_init_arg) do
    {:ok, :green}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def handle_cast(:transition, state) do
    case state do
      :green -> {:noreply, :yellow}
      :yellow -> {:noreply, :red}
      :red -> {:noreply, :green}
    end
  end

  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  @impl true
  def handle_call(:current_light, _from, state) do
    {:reply, state, state}
  end

  def current_light(pid) do
    GenServer.call(pid, :current_light)
  end
end
