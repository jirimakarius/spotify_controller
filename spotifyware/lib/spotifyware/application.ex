defmodule Spotifyware.Application do
  use Application

  def start(_type, _args) do
    Spotifyware.WifiWizard.initialize()

    opts = [strategy: :one_for_one, name: Spotifyware.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: Spotifyware.Worker.start_link(arg)
        # {Spotifyware.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    []
  end

  def children(_target) do
    [
      {Spotifyware.Button.WifiWizard, Application.get_env(:vintage_net_wizard, :gpio_pin)}
    ]
  end

  def target() do
    Application.get_env(:spotifyware, :target)
  end
end
