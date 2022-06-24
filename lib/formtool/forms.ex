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

  def serialize_by_uuid(uuid) do
    case get_form_by_uuid(uuid) do
      {:ok, form} ->
        {:ok,
         %{
           "form_uuid" => form.uuid,
           "description" => form.description,
           "components" =>
             for component <- form.components do
               %{
                 "component_uuid" => component.uuid,
                 "type" => component.type,
                 "name" => component.name
               }
             end
         }}

      {:error, _} = error ->
        error
    end
  end
end
