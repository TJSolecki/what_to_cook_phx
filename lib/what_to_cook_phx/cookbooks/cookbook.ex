defmodule WhatToCookPhx.Cookbooks.Cookbook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cookbooks" do
    field :name, :string
    field :recipe_count, :integer
    field :owner_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cookbook, attrs) do
    cookbook
    |> cast(attrs, [:name, :recipe_count])
    |> validate_required([:name, :recipe_count])
  end
end
