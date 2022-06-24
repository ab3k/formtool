defmodule Formtool.Submissions.Submission do
  @moduledoc false

  defstruct id: nil, form_uuid: nil, data: %{}, errors: %{}, changeset: nil, names: nil

  def new(id, form_uuid) do
    %__MODULE__{id: id, form_uuid: form_uuid}
  end

  def new(form_uuid) do
    %__MODULE__{id: generate_uuid(), form_uuid: form_uuid}
  end

  defp generate_uuid() do
    Ecto.UUID.generate()
  end
end
