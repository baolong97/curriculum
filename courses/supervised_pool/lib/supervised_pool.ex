defmodule SupervisedPool do
  @moduledoc """
  Documentation for `SupervisedPool`.
  """

  use Supervisor

  def start_link(opts) do
    # we've made our name configurable for demonstration purposes.
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    IO.inspect(opts)
    # System.schedulers_online() returns the number of
    # available schedulers on the current machine.
    child_specs =
      Enum.map(1..(opts[:size] || System.schedulers_online()), fn n ->
        %{
          id: :"supervised_worker_#{n}",
          start:
            {Worker, :start_link,
             [[name: String.to_atom("supervised_worker_#{n}"), registry: SupervisedPool.Registry]]}
        }
      end)

    children =
      [
        {Registry, name: SupervisedPool.Registry, keys: :duplicate}
      ] ++ child_specs

    Supervisor.init(children, strategy: :one_for_one)
  end

  def schedule_job do
    workers = Registry.lookup(SupervisedPool.Registry, :workers)
    # We grab a random worker to perform the job.
    # While not ideal, this is a very simple scheduling implementation.
    {pid, _value} = Enum.random(workers)

    Worker.perform_job(pid)
  end

  def total_workers do
    length(workers = Registry.lookup(SupervisedPool.Registry, :workers))
  end
end
