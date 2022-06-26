defmodule Formtool.Processors.Behaviour do
  @moduledoc false

  @callback process(term) :: :ok
end
