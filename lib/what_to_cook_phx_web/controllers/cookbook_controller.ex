defmodule WhatToCookPhxWeb.CookbookController do
  use WhatToCookPhxWeb, :controller

  alias WhatToCookPhx.Cookbooks
  alias WhatToCookPhx.Cookbooks.Cookbook

  def index(conn, _params) do
    cookbooks = Cookbooks.list_cookbooks()
    render(conn, :index, cookbooks: cookbooks)
  end

  def new(conn, _params) do
    changeset = Cookbooks.change_cookbook(%Cookbook{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"cookbook" => cookbook_params}) do
    case Cookbooks.create_cookbook(cookbook_params) do
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
