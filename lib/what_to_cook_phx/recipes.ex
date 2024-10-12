defmodule WhatToCookPhx.Recipes do
  @moduledoc """
  Context for creating recipes.
  """
  alias WhatToCookPhx.Ingredient
  alias Floki
  alias Jason
  alias Req
  alias WhatToCookPhx.Recipe
  alias WhatToCookPhx.Instruction
  alias WhatToCookPhx.Ingredient
  require Logger

  @spec get_recipe_from_url(String.t()) :: {:ok, %Recipe{}} | {:error, any()}
  def get_recipe_from_url(url) do
    with {:ok, page} <- get_page(url),
         {:ok, ld_json} <- get_ld_json(page),
         {:ok, ld_json_nodes} <- parse_ld_json(ld_json),
         {:ok, recipe_node} <- get_recipe_node(ld_json_nodes) do
      {:ok, parse_recipe_node(recipe_node, url)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec parse_recipe_node(map(), String.t()) :: %Recipe{}
  def parse_recipe_node(recipe_node, recipe_url) do
    %Recipe{
      cook_time: Map.get(recipe_node, "cookTime"),
      prep_time: Map.get(recipe_node, "prepTime"),
      total_time: Map.get(recipe_node, "totalTime"),
      name: Map.get(recipe_node, "name"),
      recipe_yield: parse_yield(recipe_node),
      author: Map.get(recipe_node, "author", %{}) |> Map.get("name"),
      instructions: parse_instructions(recipe_node),
      image_url: parse_image_url(recipe_node),
      ingredients: parse_ingredients(recipe_node),
      recipe_url: recipe_url
    }
  end

  @spec parse_ingredients(map()) :: [%Ingredient{}]
  def parse_ingredients(recipe_node) do
    case Map.get(recipe_node, "recipeIngredient") do
      ingredients when is_list(ingredients) ->
        Enum.map(ingredients, fn ingredient -> %Ingredient{name: ingredient} end)

      ingredient when is_bitstring(ingredient) ->
        [%Ingredient{name: ingredient}]

      _ ->
        []
    end
  end

  @spec parse_image_url(map()) :: String.t() | nil
  def parse_image_url(recipe_node) do
    case Map.get(recipe_node, "image") do
      [image_url | _] ->
        image_url

      %{url: url} ->
        url

      string when is_bitstring(string) ->
        string

      _ ->
        nil
    end
  end

  @spec parse_instructions(map()) :: [%Instruction{}]
  def parse_instructions(recipe_node) do
    case Map.get(recipe_node, "recipeInstructions") do
      list when is_list(list) ->
        list
        |> Enum.with_index(1)
        |> Enum.map(fn {instruction, step_number} ->
          %Instruction{
            name: Map.get(instruction, "name"),
            text: Map.get(instruction, "text"),
            step_number: step_number
          }
        end)

      text when is_bitstring(text) ->
        [%Instruction{text: text, step_number: 1}]

      _ ->
        Logger.warning("no recipeInstructions found on recipe_node: #{inspect(recipe_node)}")
        []
    end
  end

  @spec parse_yield(map()) :: String.t() | nil
  def parse_yield(recipe_node) do
    case Map.get(recipe_node, "recipeYield") do
      string when is_bitstring(string) ->
        string

      quantative_value when is_map(quantative_value) ->
        Map.get(quantative_value, "value")

      list when is_list(list) ->
        Enum.join(list, ", ")

      _ ->
        nil
    end
  end

  @spec get_recipe_node([map()]) :: {:ok, map()} | {:error, String.t()}
  def get_recipe_node(ld_json_nodes) do
    recipe_node = Enum.find(ld_json_nodes, fn node -> type_is_recipe(Map.get(node, "@type")) end)

    if recipe_node == nil do
      Logger.error("No recipe node found on #{inspect(ld_json_nodes)}")
      {:error, "No recipe node found on #{inspect(ld_json_nodes)}"}
    else
      {:ok, recipe_node}
    end
  end

  @spec parse_ld_json(any()) :: {:ok, [map()]} | {:error, String.t()}
  def parse_ld_json(ld_json) do
    cond do
      is_map(ld_json) ->
        cond do
          !Map.has_key?(ld_json, "@graph") and !type_is_recipe(Map.get(ld_json, "@type")) ->
            Logger.error(
              "No graph node present on ld_json, and the ld_json is not a recipe, map:\n #{inspect(ld_json)}"
            )

            {:error, "No graph node present on ld_json, and the ld_json is not a recipe."}

          type_is_recipe(Map.get(ld_json, "@type")) ->
            {:ok, [ld_json]}

          true ->
            {:ok, Map.get(ld_json, "@graph")}
        end

      is_list(ld_json) ->
        {:ok, ld_json}

      true ->
        {:error, "unable to parse ld_json #{inspect(ld_json)}"}
    end
  end

  @spec type_is_recipe(any()) :: boolean
  def type_is_recipe(type_value) do
    if is_list(type_value) do
      Enum.any?(type_value, fn type -> type === "Recipe" end)
    else
      type_value === "Recipe"
    end
  end

  @spec get_ld_json(String.t()) :: {:ok, map()} | {:ok, list()} | {:error, any()}
  defp get_ld_json(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      Floki.find(document, "script[type=\"application/ld+json\"]")
      |> Enum.at(0)
      |> elem(2)
      |> Enum.at(0)
      |> Jason.decode()
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_page(String.t()) :: {:ok, String.t()} | {:error, any()}
  defp get_page(url) do
    case Req.get(url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status}} ->
        {:error, {:unexpected_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
