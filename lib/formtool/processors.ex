defmodule Formtool.Processors do
  @moduledoc """
  The Processors context.
  """

  @processors [
    just_log: Formtool.Processors.JustLog
  ]

  @doc """
  Process data from a validated submission.

  The tasks can still decide to launch a task for the real work on their own.
  """
  def process_all(%{} = data) do
    Enum.map(
      @processors,
      fn {name, processor} ->
        result =
          Task.Supervisor.start_child(
            Formtool.Task.ProcessorSupervisor,
            fn ->
              processor.process(data)
            end,
            restart: :transient
          )

        {name, result}
      end
    )
  end
end
