defmodule MSON.Mixfile do
  use Mix.Project

  def project do
    [app: :mson,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [extra_applications: []]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, "~> 1.1", runtime: false},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp description do
    """
    Define your structs in Markdown together with documentation
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Timmo Verlaan"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tverlaan/mson"}
    ]
  end


end
