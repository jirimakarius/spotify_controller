defmodule Spotiauth.Application do
  @moduledoc false

  use Application

  @spec start(Application.start_type(), any()) :: {:error, any} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Spotiauth.TaskSupervisor},
      Spotiauth.Web.Endpoint,
      Spotiauth.Credentials
    ]

    opts = [strategy: :one_for_one, name: Spotiauth.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
