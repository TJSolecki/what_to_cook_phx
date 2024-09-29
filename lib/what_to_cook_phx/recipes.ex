defmodule WhatToCookPhx.Recipes do
  @moduledoc """
  Context for creating recipes.
  """
  alias WhatToCookPhx.Recipe
  alias Req
  alias Jason
  alias Floki

  @spec get_recipe_from_url(String.t()) :: {:ok, Map.t()} | {:error, any()}
  def get_recipe_from_url(url) do
    get_page(url) |> get_ld_json()
  end

  @spec get_ld_json(String.t()) :: {:ok, Map.t()} | {:error, any()}
  defp get_ld_json(html) do
    Floki.parse_document(html)
    |> Floki.find("script[type=application/ld+json]")
    |> Floki.text()
    |> Jason.decode()
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
