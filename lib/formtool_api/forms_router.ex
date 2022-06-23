defmodule FormtoolApi.FormsRouter do
  @moduledoc false
  use Plug.Router
  alias FormtoolApi.Forms

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get("/:uuid", to: Forms.GetAction)
end
