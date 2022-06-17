# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Formtool.Repo.insert!(%Formtool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

form1 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Form{
      id: 1,
      uuid: "06d4c473-f3f0-4ee6-9d22-e09178fcdbd5",
      title: "Form 1",
      description: "A form with components"
    },
    on_conflict: :nothing
  )

_component1 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Component{
      id: 1,
      form_id: form1.id,
      uuid: "6bc682be-209a-49cd-a267-620a2dcb03e5",
      type: "text",
      name: "email",
      weight: 1
    },
    on_conflict: :nothing
  )

_component2 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Component{
      id: 2,
      form_id: form1.id,
      uuid: "989b81da-4124-4181-b1a7-46f90b2703e7",
      type: "text",
      name: "name",
      weight: 2
    },
    on_conflict: :nothing
  )

_form2 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Form{
      id: 2,
      uuid: "1aa73cd9-d337-4664-8215-ed19103183dd",
      title: "Form 2",
      description: "An empty form"
    },
    on_conflict: :nothing
  )
