defmodule SpotiauthTest do
  use ExUnit.Case
  doctest Spotiauth

  test "Starts server" do
    assert Spotiauth.start() == :ok
  end

  test "Already started server" do
    assert Spotiauth.start() == :ok
  end

  test "Stops server" do
    Spotiauth.start()

    assert Spotiauth.stop() == :ok
  end
end
