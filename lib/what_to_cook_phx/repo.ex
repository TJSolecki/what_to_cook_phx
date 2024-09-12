defmodule WhatToCookPhx.Repo do
  use Ecto.Repo,
    otp_app: :what_to_cook_phx,
    adapter: Ecto.Adapters.Postgres
end
