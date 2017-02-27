defmodule Ui.Pin do
  @moduledoc """
  A Ui.Pin describes a physical pin on a device. This is mainly for displaying information
  about the physical pins, not for controlling them (e.g. in the case of a GPIO pin.
  """

  alias Ui.Pin

  defmodule GPIO do
    @type t :: %GPIO{}
    defstruct [:gpio_number]

    @spec description(t) :: String.t
    def description(%GPIO{gpio_number: gpio_number}) do
      "GPIO pin ##{gpio_number}"
    end
  end

  defmodule Power do
    @type t :: %Power{}
    defstruct [:voltage]

    @spec description(t) :: String.t
    def description(%Power{voltage: voltage}) do
      "#{voltage} Power pin"
    end
  end

  defmodule Ground do
    @type t :: %Ground{}
    defstruct []

    @spec description(t) :: String.t
    def description(%Ground{}) do
      "Ground pin"
    end
  end

  defmodule Other do
    defstruct [:description]
    @type t :: %Other{}

    @spec description(t) :: String.t
    def description(%Other{description: description}) do
      description
    end
  end

  @type pin_number :: non_neg_integer()

  def description(%type{} = pin) do
    type.description(pin)
  end

  ## Factory Functions

  @doc "Creates a power pin with voltage"
  @spec power(number()) :: Power.t
  def power(voltage), do: %Pin.Power{voltage: voltage}

  @doc "Creates a GPIO pin with GPIO number"
  @spec gpio(number()) :: GPIO.t
  def gpio(gpio_number), do: %Pin.GPIO{gpio_number: gpio_number}

  @doc "Creates a ground pin"
  @spec ground() :: Ground.t
  def ground(), do: %Pin.Ground{}

  @doc """
  creates an "other" pin - e.g. anything else. Will display with the data passed.
  """
  @spec other(term()) :: Other.t
  def other(description), do: %Pin.Other{description: description}
end
