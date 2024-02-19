defmodule Elmex.MixProject do
  use Mix.Project

  def project do
    [
      app: :elmex,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:file_system, "~> 0.2"},
    ]
  end
end
