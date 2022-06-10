defmodule FormtoolTest do
  @moduledoc false
  use ExUnit.Case
  doctest Formtool

  describe "Formtool.divide_strings/1" do
    test "divides integers" do
      assert Formtool.divide_strings(%{"x" => "1", "y" => "2"}) == 0.5
      assert Formtool.divide_strings(%{"x" => "3", "y" => "2"}) == 1.5
      assert Formtool.divide_strings(%{"x" => "3", "y" => "3"}) == 1.0
      assert Formtool.divide_strings(%{"x" => "3", "y" => "3", "z" => "3"}) == 1.0
    end

    test "returns an error if the strings are not parseable" do
      assert Formtool.divide_strings(%{"x" => "a", "y" => "b"}) == :error
    end

    test "raises an error if the divisor is 0" do
      assert_raise ArithmeticError, fn ->
        Formtool.divide_strings(%{"x" => "1", "y" => "0"})
      end
    end
  end
end
