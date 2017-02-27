defmodule Ui.PinController do
  use Ui.Web, :controller
  require Logger

  def show(conn, %{"pin" => pin}) do
    pin = String.to_integer(pin)
    state = Ui.Pins.read(pin)
    render conn, "show.json", pin: pin, state: state
  end
end
