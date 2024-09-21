defmodule WhatToCookPhx.Repo.Migrations.CreateInstructions do
  use Ecto.Migration

  def change do
    create table(:instructions) do
      add :step_number, :integer
      add :text, :string
      add :name, :string
      add :recipe_id, references(:recipes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:instructions, [:recipe_id])
  end
end
