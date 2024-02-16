defmodule Phelm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhelmWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phelm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phelm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Phelm.Finch},
      # Start a worker by calling: Phelm.Worker.start_link(arg)
      # {Phelm.Worker, arg},
      # Start to serve requests, typically the last entry
      PhelmWeb.Endpoint,
      {Phelm.ElmWatcher, Application.get_env(:phelm, Phelm.ElmWatcher, [])}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phelm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhelmWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp maybe_watch_elm do
    to_watch = Application.get_env(:phelm, :elm_watch, [])

    case to_watch do
      [] -> []
      files when is_list(files) -> [{Phelm.ElmWatcher, files}]
      _ -> []
    end
  end
end
