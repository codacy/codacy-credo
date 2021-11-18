defmodule CodacyCredo.MixProject do
  use Mix.Project

  def project do
    [
      app: :codacy_credo,
      version: "0.1.2",
      elixir: version_from_file(".elixir-version"),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: Coverex.Task],
      deps: deps(),
      aliases: [
        test: "test --no-start"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Codacy.Credo, []},
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "1.6.0"},
      {:poison, "4.0.1"},
      {:distillery, "2.1.1", runtime: false},
      {:mix_test_watch, "1.0.3", only: :dev, runtime: false},
      {:inch_ex, "2.0.0", only: [:dev, :test]},
      {:coverex, "1.5.0", only: :test}
    ]
  end

  defp version_from_file(file_name) do
    File.read(file_name)
    |> handle_file_version
  end

  defp handle_file_version({:ok, content}) do
    content
  end
end
