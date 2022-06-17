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

_form1 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Form{
      id: 1,
      uuid: "06d4c473-f3f0-4ee6-9d22-e09178fcdbd5",
      title: "Form 1",
      description: "A description"
    },
    on_conflict: :nothing
  )

_form2 =
  Formtool.Repo.insert!(
    %Formtool.Forms.Form{
      id: 2,
      uuid: "1aa73cd9-d337-4664-8215-ed19103183dd",
      title: "Form 2",
      description: "A description"
    },
    on_conflict: :nothing
  )
