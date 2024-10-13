defmodule WhatToCookPhx.Cookbooks do
  @moduledoc """
  The Cookbooks context.
  """

  import Ecto.Query, warn: false
  alias WhatToCookPhx.Repo

  alias WhatToCookPhx.Cookbooks.Cookbook

  @doc """
  Returns the list of cookbooks.

  ## Examples

      iex> list_cookbooks()
      [%Cookbook{}, ...]

  """
  def list_cookbooks do
    Repo.all(Cookbook)
  end

  @doc """
  Gets a single cookbook.

  Raises `Ecto.NoResultsError` if the Cookbook does not exist.

  ## Examples

      iex> get_cookbook!(123)
      %Cookbook{}

      iex> get_cookbook!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cookbook!(id), do: Repo.get!(Cookbook, id)

  @doc """
  Creates a cookbook.

  ## Examples

      iex> create_cookbook(%{field: value})
      {:ok, %Cookbook{}}

      iex> create_cookbook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cookbook(attrs \\ %{}) do
    %Cookbook{}
    |> Cookbook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cookbook.

  ## Examples

      iex> update_cookbook(cookbook, %{field: new_value})
      {:ok, %Cookbook{}}

      iex> update_cookbook(cookbook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cookbook(%Cookbook{} = cookbook, attrs) do
    cookbook
    |> Cookbook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cookbook.

  ## Examples

      iex> delete_cookbook(cookbook)
      {:ok, %Cookbook{}}

      iex> delete_cookbook(cookbook)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cookbook(%Cookbook{} = cookbook) do
    Repo.delete(cookbook)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cookbook changes.

  ## Examples

      iex> change_cookbook(cookbook)
      %Ecto.Changeset{data: %Cookbook{}}

  """
  def change_cookbook(%Cookbook{} = cookbook, attrs \\ %{}) do
    Cookbook.changeset(cookbook, attrs)
  end
end
