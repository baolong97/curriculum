defmodule Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    # Register the Worker under the PoolManager
    # We've made the : Registry configurable.
    # While not necessary, this makes our worker re-usable throughout our registry examples.
    registry = opts[:registry] || PoolManager
    Registry.register(registry, :workers, nil)

    {:ok, 0}
  end

  def perform_job(pid) do
    # Print the name of the worker or its pid
    IO.inspect(Process.info(pid)[:registered_name] || pid, label: "starting job")
    GenServer.call(pid, :perform_job)
  end

  def handle_call(:perform_job, _from, state) do
    Process.sleep(1000)
    {:reply, "response", state}
  end
end
