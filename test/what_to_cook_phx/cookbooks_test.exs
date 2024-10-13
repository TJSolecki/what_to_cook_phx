defmodule WhatToCookPhx.CookbooksTest do
  use WhatToCookPhx.DataCase

  alias WhatToCookPhx.Cookbooks

  describe "cookbooks" do
    alias WhatToCookPhx.Cookbooks.Cookbook

    import WhatToCookPhx.CookbooksFixtures

    @invalid_attrs %{name: nil, recipe_count: nil}

    test "list_cookbooks/0 returns all cookbooks" do
      cookbook = cookbook_fixture()
      assert Cookbooks.list_cookbooks() == [cookbook]
    end

    test "get_cookbook!/1 returns the cookbook with given id" do
      cookbook = cookbook_fixture()
      assert Cookbooks.get_cookbook!(cookbook.id) == cookbook
    end

    test "create_cookbook/1 with valid data creates a cookbook" do
      valid_attrs = %{name: "some name", recipe_count: 42}

      assert {:ok, %Cookbook{} = cookbook} = Cookbooks.create_cookbook(valid_attrs)
      assert cookbook.name == "some name"
      assert cookbook.recipe_count == 42
    end

    test "create_cookbook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cookbooks.create_cookbook(@invalid_attrs)
    end

    test "update_cookbook/2 with valid data updates the cookbook" do
      cookbook = cookbook_fixture()
      update_attrs = %{name: "some updated name", recipe_count: 43}

      assert {:ok, %Cookbook{} = cookbook} = Cookbooks.update_cookbook(cookbook, update_attrs)
      assert cookbook.name == "some updated name"
      assert cookbook.recipe_count == 43
    end

    test "update_cookbook/2 with invalid data returns error changeset" do
      cookbook = cookbook_fixture()
      assert {:error, %Ecto.Changeset{}} = Cookbooks.update_cookbook(cookbook, @invalid_attrs)
      assert cookbook == Cookbooks.get_cookbook!(cookbook.id)
    end

    test "delete_cookbook/1 deletes the cookbook" do
      cookbook = cookbook_fixture()
      assert {:ok, %Cookbook{}} = Cookbooks.delete_cookbook(cookbook)
      assert_raise Ecto.NoResultsError, fn -> Cookbooks.get_cookbook!(cookbook.id) end
    end

    test "change_cookbook/1 returns a cookbook changeset" do
      cookbook = cookbook_fixture()
      assert %Ecto.Changeset{} = Cookbooks.change_cookbook(cookbook)
    end
  end
end
