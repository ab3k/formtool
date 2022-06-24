defmodule Formtool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port =
      Application.get_env(:formtool, FormtoolApi.Endpoint, port: 4000)
      |> Keyword.get(:port)

    children = [
      Formtool.Repo,
      {Registry, [keys: :unique, name: Formtool.Submissions.Registry]},
      Formtool.Submissions.Supervisor,
      {Plug.Cowboy, scheme: :http, plug: FormtoolApi.Endpoint, port: port}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Formtool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
