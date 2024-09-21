defmodule WhatToCookPhx.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :image_url, :string
      add :name, :string
      add :author, :string
      add :cook_time, :string
      add :prep_time, :string
      add :total_time, :string
      add :recipe_url, :string
      add :recipe_yield, :string

      timestamps(type: :utc_datetime)
    end
  end
end
