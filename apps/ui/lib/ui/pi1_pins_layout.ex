defmodule PI1PinsLayout do
  @moduledoc """
  Raspberry PI 1 layout (26 pin version)
  https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/
  """

  import Ui.Pin

  @doc """
  map of pins
  """
  def map() do
    pins = 1..40 |> Enum.map(&pin/1)
    1..length(pins) |> Enum.zip(pins) |> Enum.into(%{})
  end
  def pin(1), do: power(3.3)
  def pin(2), do: power(5)
  def pin(3), do: gpio(2)
  def pin(4), do: power(5)
  def pin(5), do: gpio(3)
  def pin(6), do: ground()
  def pin(7), do: gpio(4)
  def pin(8), do: gpio(14)
  def pin(9), do: ground()
  def pin(10), do: gpio(15)
  def pin(11), do: gpio(17)
  def pin(12), do: gpio(18)
  def pin(13), do: gpio(27)
  def pin(14), do: ground()
  def pin(15), do: gpio(22)
  def pin(16), do: gpio(23)
  def pin(17), do: power(3.3)
  def pin(18), do: gpio(24)
  def pin(19), do: gpio(10)
  def pin(20), do: ground()
  def pin(21), do: gpio(9)
  def pin(22), do: gpio(25)
  def pin(23), do: gpio(11)
  def pin(24), do: gpio(8)
  def pin(25), do: ground()
  def pin(26), do: gpio(7)
end
