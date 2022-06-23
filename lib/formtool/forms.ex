defmodule Formtool.Forms do
  @moduledoc """
  The Forms context.
  """

  import Ecto.Query, warn: false
  alias Formtool.Repo
  alias Formtool.Forms.Form

  def get_form_by_uuid(uuid) do
    case Repo.get_by(Form, uuid: uuid) |> Repo.preload(:components) do
      nil -> {:error, :not_found}
      %Form{} = form -> {:ok, form}
    end
  end
end
