defmodule TenSummonersTales.MixProject do
  use Mix.Project

  def project do
    [
      app: :ten_summoners_tales,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TenSummonersTales.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:mox, "~> 1.0"},
      {:jason, "~> 1.3"}
    ]
  end
end
