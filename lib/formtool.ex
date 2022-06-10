defmodule Formtool do
  @moduledoc """
  Documentation for `Formtool`.
  """

  def divide_strings(%{"x" => dividend, "y" => divisor}) do
    with {x, _} <- Integer.parse(dividend),
         {y, _} <- Integer.parse(divisor) do
      x / y
    end
  end
end
