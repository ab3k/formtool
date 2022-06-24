defmodule Formtool.Submissions.Validator do
  @moduledoc """
  Validates a changeset.
  """

  import Ecto.Changeset
  require Logger

  def add_validations(changeset, validations) do
    changeset =
      Enum.reduce(validations, changeset, fn {field, field_validations}, changeset ->
        Enum.reduce(field_validations, changeset, fn {validation, opts}, changeset ->
          _validate(changeset, validation, field, opts)
        end)
      end)

    changeset
  end

  # validator implementations

  defp _validate(changeset, :required, field, true = _opts) do
    changeset
    |> validate_required(field, message: "is required")
  end

  defp _validate(changeset, :required, _field, _opts) do
    changeset
  end

  defp _validate(changeset, :email, field, true = _opts) do
    changeset
    |> validate_format(field, ~r/@/, message: "is invalid email address")
  end

  defp _validate(changeset, :email, _field, _opts) do
    changeset
  end

  # if the validator is unknown, log a warning but pass the changeset along
  defp _validate(changeset, validation, field, _opts) do
    Logger.warn("Unknown validation #{inspect(validation)} for field #{inspect(field)}")
    changeset
  end
end
