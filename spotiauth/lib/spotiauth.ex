defmodule Spotiauth do
  @moduledoc """
  Documentation for Spotiauth.
  """

  alias Spotiauth.Web.Endpoint

  def start() do
    with :ok <- Endpoint.start_server() do
      :ok
    else
      {:error, :already_started} -> :ok
      error -> error
    end
  end

  @spec stop() :: :ok | {:error, String.t()}
  def stop() do
    with :ok <- Endpoint.stop_server() do
      :ok
    else
      error -> error
    end
  end
end
