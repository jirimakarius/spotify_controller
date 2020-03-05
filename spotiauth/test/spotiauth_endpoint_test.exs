defmodule SpotiauthEndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock
  doctest Spotiauth.Web.Router

  alias Spotiauth.Web.Router

  @opts Router.init([])

  test "redirect to spotify login" do
    conn = conn(:get, "/")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 302
    [location] = get_resp_header(conn, "location")
    assert String.starts_with?(location, "https://accounts.spotify.com/authorize?")
  end

  test_with_mock "authentication", AuthRequest,
                 [post: fn params -> AuthenticationClientMock.post(params) end] do
    assert Spotiauth.Credentials.configured == false

    conn = conn(:get, "/authenticate?code=Test")
           |> Router.call(@opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert Spotiauth.Credentials.configured
  end

  test "authentication error" do
    msg = "No code provided by Spotify. Authorize your app again"

    assert_raise AuthenticationError, msg, fn ->
      conn(:get, "/authenticate")
      |> Router.call(@opts)
    end
  end
end
