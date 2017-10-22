defmodule MQTTMatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :mqtt_matcher,
      version: "0.1.0",
      elixir: "> 1.5.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "MQTTMatcher",
      source_url: "https://github.com/timbuchwaldt/mqtt_matcher",
      docs: [main: "README", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Elixir macro for matching mqtt topics."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "mqtt_matcher",
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Tim Buchwaldt"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/timbuchwaldt/mqtt_matcher"}
    ]
  end
end
