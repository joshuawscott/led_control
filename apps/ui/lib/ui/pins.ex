defmodule Ui.Pins do
  use GenServer
  @pin_numbers [4,17,27,22,5,6,13,19,26,18,23,24,25,12,16,20,21]
  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end
  def init(first_state) do
    state = Enum.reduce(@pin_numbers, first_state, fn pin_number, accum ->
      {:ok, pin} = Gpio.start_link(pin_number, :output)
      Map.put(accum, pin_number, pin)
    end)
    {:ok, state}
  end

  def pin(pid, number) do
    GenServer.call(pid, {:pin, number})
  end

  def on(pid, number) do
    GenServer.call(pid, {:on, number})
  end

  def off(pid, number) do
    GenServer.call(pid, {:off, number})
  end

  def blink(pid, number) do
    GenServer.call(pid, {:blink, number})
  end

  def handle_call({:pin, number}, _from, state) do
    pin = Map.get state, number
    {:reply, pin, state}
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

  def handle_call({:blink, number}, _from, state) do
    pin = Map.get state, number
    Enum.each(1..20, fn _ ->
      Gpio.write(pin, 1)
      :timer.sleep 250
      Gpio.write(pin, 0)
      :timer.sleep 250
    end)
    {:reply, :off, state}
  end
end
