defmodule Spotifyware.WifiWizard do
  require Logger

  def initialize() do
    Logger.info("[WifiWizard] - initialize")

    wlan =
      VintageNet.configured_interfaces()
      |> inspect

    Logger.info("[WifiWizard] - #{wlan}")

    VintageNet.configured_interfaces()
    |> Enum.any?(&(&1 =~ ~r/^wlan/))
    |> start_wizard
  end

  def on_wizard_exit() do
    Logger.info("[WifiWizard] - WiFi Wizard stopped")

    if Spotiauth.Credentials.configured() do
      Logger.info("[Spotiauth] - Already configured")
    else
      Spotiauth.start()
    end
  end

  def start_wizard(_wifi_configured \\ false)

  def start_wizard(_wifi_configured? = true) do
    Logger.info("[WifiWizard] - WiFi already configured")
    on_wizard_exit()
    {:ok}
  end

  def start_wizard(_wifi_not_configured) do
    Logger.info("[WifiWizard] - WiFi Wizard started")
    VintageNetWizard.run_wizard(on_exit: {__MODULE__, :on_wizard_exit, []})
  end
end
