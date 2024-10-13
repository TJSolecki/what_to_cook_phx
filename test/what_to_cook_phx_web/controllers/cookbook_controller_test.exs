defmodule WhatToCookPhxWeb.CookbookControllerTest do
  use WhatToCookPhxWeb.ConnCase

  import WhatToCookPhx.CookbooksFixtures

  @create_attrs %{name: "some name", recipe_count: 42}
  @update_attrs %{name: "some updated name", recipe_count: 43}
  @invalid_attrs %{name: nil, recipe_count: nil}

  describe "index" do
    test "lists all cookbooks", %{conn: conn} do
      conn = get(conn, ~p"/cookbooks")
      assert html_response(conn, 200) =~ "Listing Cookbooks"
    end
  end

  describe "new cookbook" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/cookbooks/new")
      assert html_response(conn, 200) =~ "New Cookbook"
    end
  end

  describe "create cookbook" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/cookbooks", cookbook: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/cookbooks/#{id}"

      conn = get(conn, ~p"/cookbooks/#{id}")
      assert html_response(conn, 200) =~ "Cookbook #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/cookbooks", cookbook: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Cookbook"
    end
  end

  describe "edit cookbook" do
    setup [:create_cookbook]

    test "renders form for editing chosen cookbook", %{conn: conn, cookbook: cookbook} do
      conn = get(conn, ~p"/cookbooks/#{cookbook}/edit")
      assert html_response(conn, 200) =~ "Edit Cookbook"
    end
  end

  describe "update cookbook" do
    setup [:create_cookbook]

    test "redirects when data is valid", %{conn: conn, cookbook: cookbook} do
      conn = put(conn, ~p"/cookbooks/#{cookbook}", cookbook: @update_attrs)
      assert redirected_to(conn) == ~p"/cookbooks/#{cookbook}"

      conn = get(conn, ~p"/cookbooks/#{cookbook}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, cookbook: cookbook} do
      conn = put(conn, ~p"/cookbooks/#{cookbook}", cookbook: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Cookbook"
    end
  end

  describe "delete cookbook" do
    setup [:create_cookbook]

    test "deletes chosen cookbook", %{conn: conn, cookbook: cookbook} do
      conn = delete(conn, ~p"/cookbooks/#{cookbook}")
      assert redirected_to(conn) == ~p"/cookbooks"

      assert_error_sent 404, fn ->
        get(conn, ~p"/cookbooks/#{cookbook}")
      end
    end
  end

  defp create_cookbook(_) do
    cookbook = cookbook_fixture()
    %{cookbook: cookbook}
  end
end
