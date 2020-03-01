defmodule Spotiauth.Credentials do
  use Agent

  alias Spotify.Credentials

  def start_link(_) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def update(credentials = %Credentials{}) do
    Agent.update(__MODULE__, fn _ -> credentials end)
  end

  def configured do
    case get() do
      nil ->
        false

      %Credentials{} ->
        true
    end
  end
end
