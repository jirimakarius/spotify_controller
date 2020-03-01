defmodule Spotifyware.Button.WifiWizard do
  use GenServer

  @moduledoc """
  This GenServer starts the wizard if a button is depressed for long enough.
  """

  require Logger

  alias Circuits.GPIO
  alias Spotifyware.WifiWizard

  @doc """
  Start the button monitor
  Pass an index to the GPIO that's connected to the button.
  """
  @spec start_link(non_neg_integer()) :: GenServer.on_start()
  def start_link(gpio_pin) do
    Logger.info("[WifiWizard - Button] - Starting Genserver")
    GenServer.start_link(__MODULE__, gpio_pin)
  end

  @impl true
  def init(gpio_pin) do
    Logger.info("[WifiWizard - Button] - Subcribe to pin #{gpio_pin}")
    {:ok, gpio} = GPIO.open(gpio_pin, :input)
    :ok = GPIO.set_interrupts(gpio, :both)
    Logger.info("[WifiWizard - Button] - Initialized")
    {:ok, %{pin: gpio_pin, gpio: gpio}}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, 1}, %{pin: gpio_pin} = state) do
    # Button pressed. Start a timer to launch the wizard when it's long enough
    Logger.info("[WifiWizard - Button] - Button pushed")
    {:noreply, state, 5_000}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, 0}, %{pin: gpio_pin} = state) do
    # Button released. The GenServer timer is implicitly cancelled by receiving this message.
    Logger.info("[WifiWizard - Button] - Button released")
    {:noreply, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    Logger.info("[WifiWizard - Button] - Starting wizard")
    :ok = WifiWizard.start_wizard()
    {:noreply, state}
  end
end
