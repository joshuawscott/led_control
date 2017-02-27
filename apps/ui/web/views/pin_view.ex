defmodule Ui.PinView do
  use Ui.Web, :view
  require Logger

  def render("show.json", %{pin: pin, state: state}) do
    %{ pin: pin, state: state }
  end
end
