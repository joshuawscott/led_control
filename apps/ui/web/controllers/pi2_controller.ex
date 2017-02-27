defmodule Ui.PI2Controller do
  use Ui.Web, :controller

  def index(conn, _params) do
    pins = Ui.PI2PinLayout.map()
    render conn, "index.html", pins: pins
  end
end

