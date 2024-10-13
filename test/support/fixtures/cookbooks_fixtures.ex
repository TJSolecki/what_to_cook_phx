defmodule WhatToCookPhx.CookbooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhatToCookPhx.Cookbooks` context.
  """

  @doc """
  Generate a cookbook.
  """
  def cookbook_fixture(attrs \\ %{}) do
    {:ok, cookbook} =
      attrs
      |> Enum.into(%{
        name: "some name",
        recipe_count: 42
      })
      |> WhatToCookPhx.Cookbooks.create_cookbook()

    cookbook
  end
end
