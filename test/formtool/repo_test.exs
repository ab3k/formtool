defmodule Formtool.RepoTest do
  @moduledoc false

  # Once the mode is manual, tests can also be async
  use ExUnit.Case, async: true

  import Ecto.Query, only: [from: 2]
  alias Formtool.Repo

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "insert and query from the Repo" do
    {1, [%{id: new_id}]} =
      Formtool.Repo.insert_all(
        "forms",
        [
          %{
            uuid: Ecto.UUID.bingenerate(),
            inserted_at: NaiveDateTime.utc_now(),
            updated_at: NaiveDateTime.utc_now()
          }
        ],
        returning: [:id]
      )

    # Create a query
    query =
      from(f in "forms",
        select: f.id
      )

    # Send the query to the repository
    form_ids = Repo.all(query)
    assert Enum.member?(form_ids, new_id) == true
  end
end
