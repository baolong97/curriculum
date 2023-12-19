defmodule TrafficLightsLightTest do
  use ExUnit.Case
  doctest TrafficLights

  test "current_light/1 default" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    assert TrafficLights.Light.current_light(pid) == :green
  end

  test "transition/1 green->yellow" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :yellow
  end

  test "transition/1 yellow->red" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :red
  end

  test "transition/1 red->green" do
    {:ok, pid} = TrafficLights.Light.start_link([])
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :green
  end
end
