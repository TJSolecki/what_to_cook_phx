defmodule WhatToCookPhx.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :name, :string
    field :author, :string
    field :image_url, :string
    field :cook_time, :string
    field :prep_time, :string
    field :total_time, :string
    field :recipe_url, :string
    field :recipe_yield, :string

    has_many :instructions, WhatToCookPhx.Instruction
    has_many :ingredients, WhatToCookPhx.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [
      :image_url,
      :name,
      :author,
      :cook_time,
      :prep_time,
      :total_time,
      :recipe_url,
      :recipe_yield
    ])
    |> validate_required([
      :image_url,
      :name,
      :author,
      :cook_time,
      :prep_time,
      :total_time,
      :recipe_url,
      :recipe_yield
    ])
    |> cast_assoc(:instructions, with: &WhatToCookPhx.Instruction.changeset/2)
    |> cast_assoc(:ingredients, with: &WhatToCookPhx.Ingredient.changeset/2)
  end
end
