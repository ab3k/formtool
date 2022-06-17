defmodule Formtool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port =
      Application.get_env(:formtool, Formtool.Router, port: 4000)
      |> Keyword.get(:port)

    children = [
      {Plug.Cowboy, scheme: :http, plug: Formtool.Router, port: port}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Formtool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
