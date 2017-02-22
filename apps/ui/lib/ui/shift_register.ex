defmodule ShiftRegister do
  @moduledoc """
  Controls a 74hc595 shift register

  Connect GPIO pins on your PI to pins 11, 12, 14 of the 74hc595.

  For an 74hc595n, if you put the package pins down, the pin layout looks like this (`U` is the
  notch on the end of the package.)

  ```
  output1 -> 1 U 16 <- 5V power in
  output2 -> 2   15 <- output0
  output3    3   14 <- data
  output4    4   13 <- connect to ground
  output5    5   12 <- latch
  output6    6   11 <- clock
  output7    7   10 <- Master Reset (connect to ground)
  ground ->  8   9  <- Q7S (?)
  ```

  To start it up, pass in the latch pin, the clock pin, and the data pin.
  latch pin connects to STCP (pin 12) of the 74hc595
  clock pin connects to SHCP (pin 11) of the 74hc595
  data pin connects to DS (pin 14) of the 74hc595
  """
  use GenServer
  use Bitwise

  @latch_pin 5
  @clock_pin 6
  @data_pin 4

  @type pin() :: non_neg_integer()

  defmodule State do
    @moduledoc "Container for the ShiftRegister's state"
    defstruct [:latch_pin, :clock_pin, :data_pin]
  end
  alias ShiftRegister.State

  @doc """
  Takes the 3 pin numbers that are needed to operate the shift register. See module documentation
  for detail.
  """
  def start_link(latch_pin \\ @latch_pin, clock_pin \\ @clock_pin, data_pin \\ @data_pin) do
    GenServer.start_link(__MODULE__, {latch_pin, clock_pin, data_pin})
  end

  @spec init({pin, pin, pin}) :: {:ok, %State{}}
  def init({latch_pin_num, clock_pin_num, data_pin_num}) do
    {:ok, latch_pin} =  Gpio.start_link(latch_pin_num, :output)
    {:ok, clock_pin} =  Gpio.start_link(clock_pin_num, :output)
    {:ok, data_pin} =  Gpio.start_link(data_pin_num, :output)
    {:ok, %State{latch_pin: latch_pin, clock_pin: clock_pin, data_pin: data_pin}}
  end

  @doc """
  Sends data into the shift register
  """
  @spec shift_out(pid(), non_neg_integer()) :: :ok
  def shift_out(pid, value) do
    GenServer.call(pid, {:shift_out, value})
  end

  # Junk
  def display(pid, 0), do: ShiftRegister.shift_out(pid, 0b11111100)
  def display(pid, 1), do: ShiftRegister.shift_out(pid, 0b00110000)
  def display(pid, 2), do: ShiftRegister.shift_out(pid, 0b01101110)
  def display(pid, 3), do: ShiftRegister.shift_out(pid, 0b01111010)
  def display(pid, 4), do: ShiftRegister.shift_out(pid, 0b10110010)
  def display(pid, 5), do: ShiftRegister.shift_out(pid, 0b11011010)
  def display(pid, 6), do: ShiftRegister.shift_out(pid, 0b11011110)
  def display(pid, 7), do: ShiftRegister.shift_out(pid, 0b01110000)
  def display(pid, 8), do: ShiftRegister.shift_out(pid, 0b11111110)
  def display(pid, 9), do: ShiftRegister.shift_out(pid, 0b11111010)

  def handle_call({:shift_out, value}, _from, state) do
    require Logger
    Logger.info("Setting latch pin to 0")
    Gpio.write(state.latch_pin, 0)
    Enum.each(0..7, fn n ->
      mask = 1 <<< n
      overlap = value &&& mask
      pin_val = if overlap == 0 do
        0
      else
        1
      end
      Logger.info("setting data pin to #{pin_val}")
      Gpio.write(state.data_pin, pin_val)
      # Cycle the clock
      Logger.info "Clock Cycle"
      Gpio.write(state.clock_pin, 1)
      Gpio.write(state.clock_pin, 0)
    end)

    Logger.info("Setting latch pin to 1")
    Gpio.write(state.latch_pin, 1)
    {:reply, :ok, state}
  end

end
