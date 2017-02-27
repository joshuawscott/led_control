defmodule Ui.Pins do
  @moduledoc """
  This is an abstraction layer for the underlying GPIO pin interface.
  Holds the GPIO pin pids internally to allow easier manipulation.
  """
  use GenServer

  @type pin_number :: non_neg_integer()

  defmodule GPIOPin do
    @moduledoc """
    Information about a GPIO pin.
    """
    @type t :: %GPIOPin{}
    defstruct [:mode, :state, :pid]
  end

  @doc """
  Starts the Ui.Pins server. Only one is allowed per VM.
  the 
  """
  @spec start_link([pin_number]) :: GenServer.start
  def start_link(pins) do
    GenServer.start_link(__MODULE__, pins, name: __MODULE__)
  end

  def init(pins) do
    state = Enum.reduce(pins, %{}, fn pin_number, accum ->
      {:ok, pid} = Gpio.start_link(pin_number, :output)
      Gpio.write(pid, 0)
      pin = %GPIOPin{pid: pid, state: 0, mode: :output}

      Map.put(accum, pin_number, pin)
    end)
    {:ok, state}
  end

  @doc """
  Get pin object of the underlying Gpio process for a pin to use lower-level operations.
  """
  @spec pin(pin_number()) :: GPIOPin.t
  def pin(number) when is_integer(number) do
    GenServer.call(__MODULE__, {:pin, number})
  end

  @doc "Returns the state of the pin"
  @spec read(pin_number()) :: 1 | 0
  def read(number) when is_integer(number) do
    GenServer.call(__MODULE__, {:read, number})
  end

  @doc "Sets pin to 1"
  @spec on(pin_number()) :: :on
  def on(number) when is_integer(number) do
    GenServer.call(__MODULE__, {:on, number})
  end

  @doc "Sets pin to 0"
  @spec off(pin_number()) :: :off
  def off(number) when is_integer(number) do
    GenServer.call(__MODULE__, {:off, number})
  end

  @doc """
  turn pin on for `time` ms, then off for `length` ms. Repeat `times` times.

  Note that this is synchronous, so it sets the appropriate timeout in the GenServer
  call, but if any other GenServer is waiting, it might time out.
  """
  @spec blink(pin_number(), pos_integer(), pos_integer()) :: :off
  def blink(number, times \\ 10, time \\ 250) when is_integer(number) do
    # Each on/off blink takes `time * 2` ms, and we do it `times` times, and add 500ms padding
    timeout = times * time * 2 + 500
    GenServer.call(__MODULE__, {:blink, number, times, time}, timeout)
  end

  def handle_call({:pin, number}, _from, state) do
    pin = Map.get state, number
    {:reply, pin, state}
  end

  def handle_call({:read, number}, _from, state) do
    pin = Map.get state, number
    value = Gpio.read(pin.pid)
    {:reply, value, state}
  end

  def handle_call({:on, number}, _from, state) do
    pin = Map.get state, number
    Gpio.write(pin, 1)
    {:reply, :on, state}
  end

  def handle_call({:off, number}, _from, state) do
    pin = Map.get state, number
    Gpio.write(pin, 0)
    {:reply, :off, state}
  end

  def handle_call({:blink, number, times, time}, _from, state) do
    pin = Map.get state, number
    Enum.each(1..times, fn _ ->
      Gpio.write(pin, 1)
      :timer.sleep time
      Gpio.write(pin, 0)
      :timer.sleep time
    end)
    {:reply, :off, state}
  end
end
