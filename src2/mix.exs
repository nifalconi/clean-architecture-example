defmodule CleanArchitectureExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :clean_architecture_example,
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A Clean Architecture example in Elixir",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {CleanArchitectureExample.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.17"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "clean_architecture_example",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nifalconi/clean-architecture-example"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
