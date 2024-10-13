defmodule WhatToCookPhxWeb.CookbookHTML do
  use WhatToCookPhxWeb, :html

  embed_templates "cookbook_html/*"

  @doc """
  Renders a cookbook form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def cookbook_form(assigns)
end
