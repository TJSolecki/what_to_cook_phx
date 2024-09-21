defmodule WhatToCookPhx.Instruction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructions" do
    field :name, :string
    field :text, :string
    field :step_number, :integer

    belongs_to :recipe, WhatToCookPhx.Recipe

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(instruction, attrs) do
    instruction
    |> cast(attrs, [:step_number, :text, :name])
    |> validate_required([:step_number, :text])
  end
end
