defmodule Formtool.Processors.JustLog do
  @moduledoc false

  @behaviour Formtool.Processors.Behaviour

  require Logger

  @impl true
  def process(data) do
    # for showcasing: make it randomly "slow"
    random_runtime = :rand.uniform(2_500)
    pid = self()

    Task.start_link(fn ->
      Process.sleep(random_runtime)
      Logger.info(inspect([random_runtime, pid, self(), data]))
    end)

    :ok
  end
end
