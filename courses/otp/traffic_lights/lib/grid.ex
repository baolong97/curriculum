defmodule TrafficLights.Grid do
  use GenServer

  @impl true
  def init(_init_arg) do
    {:ok,
     %{
       index: 0,
       lights:
         Enum.map(1..5, fn _ ->
           {:ok, pid} = TrafficLights.Light.start_link([])
           pid
         end)
     }}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def handle_cast(:transition, state) do
    Enum.at(state.lights, state.index) |> TrafficLights.Light.transition()
    {:noreply, %{state | index: rem(state.index + 1, 5)}}
  end

  def transition(pid) do
    GenServer.cast(pid, :transition)
  end

  @impl true
  def handle_call(:current_light, _from, state) do
    lights = Enum.map(state.lights, &TrafficLights.Light.current_light/1)
    {:reply, lights, state}
  end

  def current_lights(pid) do
    GenServer.call(pid, :current_light)
  end
end
