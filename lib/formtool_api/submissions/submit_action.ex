defmodule FormtoolApi.Submissions.SubmitAction do
  @moduledoc false

  alias Formtool.{Forms, Submissions}

  @defaults [responder: FormtoolApi.Submissions.SubmitResponder]

  def init(opts \\ []) do
    @defaults
    |> Keyword.merge(opts)
  end

  def call(conn, opts) do
    responder = Keyword.fetch!(opts, :responder)

    result =
      with %{"form_uuid" => raw_uuid} <- conn.body_params,
           %{"submitted_data" => data} <- conn.body_params,
           {:ok, uuid} <- Ecto.UUID.cast(raw_uuid),
           {:ok, form} <- Forms.get_form_by_uuid(uuid),
           {:ok, submission} <- Submissions.start_submission(form),
           {:ok, changeset, permitted} <- Submissions.get_changeset_and_permitted(submission) do
        validations = Forms.Form.validations(form)

        changeset
        |> Ecto.Changeset.cast(data, permitted)
        |> Submissions.Validator.add_validations(validations)
        |> Ecto.Changeset.apply_action(:update)
      else
        _ -> :error
      end

    conn
    |> responder.respond(result)
  end
end
