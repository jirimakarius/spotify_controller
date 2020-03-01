import Config

config :spotify_ex,
  port: 4000,
  scopes: [
    "user-modify-playback-state",
    "user-read-playback-state",
    "user-read-currently-playing",
    "user-read-email",
    "user-library-read",
    "user-top-read"
  ],
  callback_url: "http://localhost:4000/authenticate"

import_config "#{Mix.env()}.secret.exs"
