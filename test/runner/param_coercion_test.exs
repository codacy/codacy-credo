defmodule Codacy.Credo.ParamCoercionTest do
  alias Codacy.Credo.Config
  use ExUnit.Case

  defp coerce(check, name, value),
    do: Config.parameters_to_check_params(%{name: name, value: value}, check)

  test "converts strings to atoms when the default is an atom" do
    assert {:sort_method, :alpha} ==
             coerce(Credo.Check.Readability.AliasOrder, "sort_method", "alpha")
  end

  test "converts list items to atoms when the defaults are atoms" do
    assert {:ignore, [:error, :warn]} ==
             coerce(Credo.Check.Warning.LazyLogging, "ignore", ["error", "warn"])
  end

  test "converts module names and regexes when the defaults mix them" do
    {:ignore_modules_using, [module, regex]} =
      coerce(Credo.Check.Readability.ModuleDoc, "ignore_modules_using", [
        "Elixir.Ecto.Schema",
        "\\.Web$"
      ])

    assert module == Ecto.Schema
    assert Regex.source(regex) == "\\.Web$"
  end

  test "converts strings to regexes when the defaults are regexes" do
    {:ignore_names, [regex]} =
      coerce(Credo.Check.Readability.ModuleDoc, "ignore_names", ["\\.Repo$"])

    assert Regex.match?(regex, "MyApp.Repo")
  end

  test "keeps strings when the defaults are strings" do
    assert {:excluded_namespaces, ["File"]} ==
             coerce(Credo.Check.Design.AliasUsage, "excluded_namespaces", ["File"])
  end

  test "keeps numbers and booleans" do
    assert {:max_length, 100} ==
             coerce(Credo.Check.Readability.MaxLineLength, "max_length", 100)

    assert {:ignore_definitions, false} ==
             coerce(Credo.Check.Readability.MaxLineLength, "ignore_definitions", false)
  end
end
