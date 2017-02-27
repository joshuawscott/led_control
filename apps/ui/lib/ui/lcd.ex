defmodule Ui.Lcd do
  # This is where the chars are stored in the ROM. the '!' is 33 (binary 00100001)
  @charmap %{
    0 => "±",
    1 => " ", # three equals
    2 => " ", # backward 7
    3 => " ", # upsidedownbackwards 7
    12 => "="
  }

  def address("!"), do: 0b0010_0001
  def address("\""), do: 0b0010_0010
  def address("\""), do: 0b0010_0001
end
