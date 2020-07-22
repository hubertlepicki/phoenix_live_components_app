defmodule App.Thing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "things" do
    field :name, :string
    field :type, :string

    belongs_to :box, App.Box

    timestamps()
  end

  @doc false
  def changeset(thing, attrs) do
    thing
    |> cast(attrs, [:type, :name, :box_id])
    |> validate_required([:type, :name, :box_id])
  end
end
