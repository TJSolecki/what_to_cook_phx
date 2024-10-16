defmodule WhatToCookPhx.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :name, :string

    belongs_to :recipe, WhatToCookPhx.Recipe

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
