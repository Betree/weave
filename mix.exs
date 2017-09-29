defmodule Weave.Mixfile do
  use Mix.Project

  def project do
    [ app: :weave,
      version: "3.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env),
      aliases: aliases(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      docs: [main: "readme", extras: ["README.md"]]
    ]
  end

  def application do
    [ applications: [
      :logger
    ] ]
  end

  def deps do
    [
      {:cabbage, "~> 0.3.2", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end

  def aliases do
    [ "init": ["local.hex --force", "deps.get"]
    ]
  end

  defp description do
    """
    A just-in-time configuration loader for Elixir projects.
    """
  end

  defp package do
    [ name: :weave,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["GT8Online"],
      licenses: ["MIT"],
      links: %{"Source Code" => "https://gitlab.com/gt8/open-source/elixir/weave"}]
  end

  defp elixirc_paths(:dev),   do: ["lib"]
  defp elixirc_paths(:test),  do: ["test", "test/support", "example"] ++ elixirc_paths(:dev)
  defp elixirc_paths(_),      do: ["lib"]
end
