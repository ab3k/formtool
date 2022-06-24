defmodule FormtoolApi.SubmissionsRouter do
  @moduledoc false
  use Plug.Router
  alias FormtoolApi.Submissions

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post("/submit", to: Submissions.SubmitAction)
end
