defmodule WhatToCookPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WhatToCookPhxWeb.Telemetry,
      WhatToCookPhx.Repo,
      {DNSCluster, query: Application.get_env(:what_to_cook_phx, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WhatToCookPhx.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WhatToCookPhx.Finch},
      # Start a worker by calling: WhatToCookPhx.Worker.start_link(arg)
      # {WhatToCookPhx.Worker, arg},
      # Start to serve requests, typically the last entry
      WhatToCookPhxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhatToCookPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WhatToCookPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
