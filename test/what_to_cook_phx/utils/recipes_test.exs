defmodule WhatToCookPhx.Utils.RecipeUtilsTest do
  use ExUnit.Case
  alias WhatToCookPhx.Utils.RecipeUtils
  require Logger

  test "get_recipe_from_url returns a map" do
    {:ok, recipe} =
      RecipeUtils.get_recipe_from_url("https://downshiftology.com/recipes/shakshuka/")

    assert is_map(recipe)
  end
end
