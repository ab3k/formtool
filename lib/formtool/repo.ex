defmodule Formtool.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :formtool,
    adapter: Ecto.Adapters.Postgres
end
