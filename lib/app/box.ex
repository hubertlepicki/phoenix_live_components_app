defmodule App.Box do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boxes" do
    timestamps()
  end

  @doc false
  def changeset(box, attrs) do
    box
    |> cast(attrs, [])
    |> validate_required([])
  end
end
