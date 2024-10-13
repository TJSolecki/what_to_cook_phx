defmodule WhatToCookPhx.Repo.Migrations.CreateCookbooks do
  use Ecto.Migration

  def change do
    create table(:cookbooks) do
      add :name, :string
      add :recipe_count, :integer
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:cookbooks, [:owner_id])
  end
end
