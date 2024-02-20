defmodule SupervisedPool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: SupervisedPool.Worker.start_link(arg)
      # {SupervisedPool.Worker, arg}
      {Registry, name: :poolboy_registry, keys: :duplicate},
      :poolboy.child_spec(
        :worker,
        [
          name: {:local, :worker},
          worker_module: Worker,
          size: 4
        ],
        registry: :poolboy_registry
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SupervisedPool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
