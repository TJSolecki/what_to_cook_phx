defmodule WhatToCookPhx.RecipesTest do
  use ExUnit.Case
  alias WhatToCookPhx.Recipes
  require Logger

  test "get_recipe_from_url returns a map" do
    {:ok, recipe} = Recipes.get_recipe_from_url("https://downshiftology.com/recipes/shakshuka/")
    assert is_map(recipe)
  end
end
