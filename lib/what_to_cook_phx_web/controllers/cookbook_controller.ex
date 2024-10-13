defmodule WhatToCookPhxWeb.CookbookController do
  use WhatToCookPhxWeb, :controller

  alias WhatToCookPhx.Cookbooks
  alias WhatToCookPhx.Cookbooks.Cookbook
  require Logger

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id

    cookbooks = Cookbooks.list_user_cookbooks(user_id)
    Logger.info("cookbooks for user #{user_id}: #{inspect(cookbooks)}")
    render(conn, :index, cookbooks: cookbooks)
  end

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id

    changeset = Cookbooks.change_cookbook(%Cookbook{owner_id: user_id, recipe_count: 0})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"cookbook" => %{"name" => name}}) do
    user_id = conn.assigns.current_user.id

    case Cookbooks.create_cookbook(%{owner_id: user_id, recipe_count: 0, name: name}) do
      {:ok, cookbook} ->
        conn
        |> put_flash(:info, "Cookbook created successfully.")
        |> redirect(to: ~p"/cookbooks/#{cookbook}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cookbook = Cookbooks.get_cookbook!(id)
    render(conn, :show, cookbook: cookbook)
  end

  def edit(conn, %{"id" => id}) do
    cookbook = Cookbooks.get_cookbook!(id)
    changeset = Cookbooks.change_cookbook(cookbook)
    render(conn, :edit, cookbook: cookbook, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cookbook" => cookbook_params}) do
    cookbook = Cookbooks.get_cookbook!(id)

    case Cookbooks.update_cookbook(cookbook, cookbook_params) do
      {:ok, cookbook} ->
        conn
        |> put_flash(:info, "Cookbook updated successfully.")
        |> redirect(to: ~p"/cookbooks/#{cookbook}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, cookbook: cookbook, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cookbook = Cookbooks.get_cookbook!(id)
    {:ok, _cookbook} = Cookbooks.delete_cookbook(cookbook)

    conn
    |> put_flash(:info, "Cookbook deleted successfully.")
    |> redirect(to: ~p"/cookbooks")
  end
end
