defmodule Spotiauth.Web.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :spotifyware

  require Logger

  alias Spotiauth.{Web.Endpoint, Credentials}

  plug(Plug.Logger, log: :debug)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    redirect(conn, Spotify.Authorization.url())
  end

  get "/authenticate" do
    case Spotify.Authentication.authenticate(conn, conn.params) do
      {:ok, conn} ->
        conn
        |> Spotify.Credentials.new()
        |> Credentials.update()

        Task.Supervisor.start_child(Spotiauth.TaskSupervisor, fn ->
          :timer.sleep(3000)
          Endpoint.stop_server()
        end)

        send_resp(conn, 200, "Success")

      {:error, reason, conn} ->
        Logger.warn("[Spotiauth] - spotify authenticate error: #{inspect(reason)}")
        redirect(conn, Spotify.Authorization.url())
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp redirect(conn, to) do
    conn
    |> put_resp_header("location", to)
    |> send_resp(302, "")
  end
end
