import Config

config :spotifyware, target: Mix.target()

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :nerves, source_date_epoch: "1583006985"

config :logger, backends: [RingLogger]

config :ring_logger,
  application_levels: %{spotifyware: :info},
  level: :error

if Mix.target() != :host do
  import_config "target.exs"
end
