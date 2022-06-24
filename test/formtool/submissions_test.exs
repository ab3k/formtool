defmodule Formtool.SubmissionsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Formtool.Forms.{Form, Component}
  alias Formtool.Repo
  alias Formtool.Submissions

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  setup do
    form = %Form{title: "Test"} |> Repo.insert!()
    _component1 = %Component{form_id: form.id, type: "text", name: "component1"} |> Repo.insert!()
    _component2 = %Component{form_id: form.id, type: "text", name: "email"} |> Repo.insert!()

    %{form: form}
  end

  describe "submissions" do
    test "build a new submission", %{form: form} do
      {:ok, submission} = Submissions.start_submission(form)

      assert submission.id != nil
    end

    test "get a changeset for a submission", %{form: form} do
      {:ok, submission} = Submissions.start_submission(form)

      {:ok, changeset, permitted} = Submissions.get_changeset_and_permitted(submission)

      assert changeset != nil
      assert permitted == [:component1, :email]
    end
  end
end
