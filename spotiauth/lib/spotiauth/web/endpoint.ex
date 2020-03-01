defmodule Spotiauth.Web.Endpoint do
  use DynamicSupervisor

  require Logger

  alias Spotiauth.Web.Router

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @doc """
  Start the web server
  If the web server is started then `{:error, already_started}` is returned.
  Only one server can be running at a time.
  """
  def start_server() do
    Logger.info("[Spotiauth] - Server starting")

    with {:ok, _pid} <- DynamicSupervisor.start_child(__MODULE__, webserver()) do
      :ok
    else
      {:error, :max_children} -> {:error, :already_started}
      error -> error
    end
  end

  @doc """
  Stop the web server
  """
  @spec stop_server() :: :ok | {:error, :not_found}
  def stop_server() do
    Logger.info("[Spotiauth] - Server stopping")

    case DynamicSupervisor.which_children(__MODULE__) do
      [] ->
        {:error, :not_found}

      children ->
        Enum.map(
          children,
          &DynamicSupervisor.terminate_child(__MODULE__, elem(&1, 1))
        )
    end
  end

  @impl DynamicSupervisor
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 1)
  end

  defp webserver() do
    Plug.Cowboy.child_spec(
      plug: Router,
      scheme: :http,
      port: Application.get_env(:spotify_ex, :port)
    )
  end
end
