defmodule Codacy.Credo.Generator.Patterns do
  @moduledoc """
  Builds patterns.json from checks specified in `Credo.ConfigFile`
  """

  alias Codacy.Credo.Config

  @securityPatterns %{
    "warning_i_ex_pry" => "CommandInjection",
    "warning_unsafe_exec" => "CommandInjection"
  }

  defp default_patterns() do
    [
      "consistency_line_endings",
      "consistency_space_around_operators",
      "consistency_space_in_parentheses",
      "consistency_tabs_or_spaces",
      "design_alias_usage",
      "design_tag_fixme",
      "design_tag_todo",
      "readability_max_line_length",
      "readability_redundant_blank_lines",
      "readability_semicolons",
      "readability_space_after_commas",
      "readability_trailing_blank_line",
      "readability_trailing_white_space",
      "refactor_double_boolean_negation",
      "warning_io_inspect"
    ]
  end

  def generate() do
    File.cwd!()
    |> load_checks
    |> patterns_json
    |> write_patterns
  end

  def load_checks(dir) do
    search_dir =
      if !File.exists?(dir) do
        File.cwd!()
      else
        dir
      end

    Config.config_or_default(search_dir)
    |> case do
      {:ok, config} ->
        Map.get(config, :checks)
        |> Enum.sort()

      {:error, errorMsg} ->
        raise inspect(errorMsg)
    end
  end

  def write_patterns(patterns) do
    encoded = Poison.encode!(patterns, pretty: true)
    File.write!("./docs/patterns.json", encoded, [:binary])
  end

  @doc """
  Utility function to get a map of pattern_ids => Check module
  """
  def pattern_id_map do
    load_checks(Config.defaultConfigPath())
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(fn check -> {check_pattern_id({check}), check} end)
    |> Map.new()
  end

  @doc """
  Convert Credo.Check into a valid Patterns Map
  """
  def check_to_pattern(check) do
    patternId = check_pattern_id(check)
    {category, subcategory} = check_to_category(check, patternId)
    parameters = check_to_parameters(check)
    enabled = patternId in default_patterns()

    %{
      patternId: patternId,
      level: check_to_level(check),
      category: category,
      subcategory: subcategory,
      parameters:
        if length(parameters) == 0 do
          nil
        else
          parameters
        end,
      enabled: enabled
    }
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end

  def patterns_json(checks) do
    %{
      name: "credo",
      version: Credo.version(),
      patterns: Enum.map(checks, &check_to_pattern/1)
    }
  end

  @doc """
  Transform Check params into Codacy Parameters

  ## Examples
    iex> Codacy.Credo.Generator.Patterns.check_to_parameters({Credo.Check.Refactor.PipeChainStart})
    [
      %{default: [], name: "excluded_argument_types"},
      %{default: [], name: "excluded_functions"}
    ]
  """
  @spec check_to_parameters(tuple) :: [map]
  def check_to_parameters({check, params}) when params != false do
    check.params_names
    |> Enum.map(
      &(fn name ->
          format_parameters({name, params[name] || check.params_defaults[name]})
        end).(&1)
    )
  end

  def check_to_parameters({check, false}), do: check_to_parameters({check})

  def check_to_parameters({check}) do
    check.params_defaults
    |> Enum.map(&format_parameters/1)
  end

  defp format_parameters({name, default}) do
    %{
      name: name |> Atom.to_string(),
      default: format_default(default)
    }
  end

  # Regex needs to be coerced into a string, not sure what to do when we convert this back to regex
  defp format_default(default) when is_list(default), do: Enum.map(default, &format_default/1)
  defp format_default(%Regex{} = regex), do: Regex.source(regex)
  defp format_default(default), do: default

  @doc """
  Converts Check from config into Codacy priority

  ## Example
    iex> Codacy.Credo.Generator.Patterns.check_to_level({Credo.Check.Refactor.LongQuoteBlocks})
    "Error"
    iex> Codacy.Credo.Generator.Patterns.check_to_level({Credo.Check.Refactor.LongQuoteBlocks, [priority: :low]})
    "Info"
  """
  @spec check_to_level(tuple) :: String.t()
  def check_to_level({check}), do: priority_to_level(check.base_priority)

  def check_to_level({_check, [priority: priority]}) do
    priority
    |> Credo.Priority.to_integer()
    |> priority_to_level()
  end

  def check_to_level({check, _opts}), do: priority_to_level(check.base_priority)

  @doc """
  Convert Credo Priority to Codacy Level

  ## Example
    iex> Codacy.Credo.Generator.Patterns.priority_to_level(10)
    "Warning"
    iex> Codacy.Credo.Generator.Patterns.priority_to_level(11)
    "Error"
  """
  @spec priority_to_level(integer) :: String.t()
  def priority_to_level(priority) do
    case priority do
      x when x > 10 -> "Error"
      x when x >= 1 -> "Warning"
      _ -> "Info"
    end
  end

  @doc """
  Convert Check Categories into Codacy Categories
  """
  @spec check_to_category(tuple, String) :: tuple
  def check_to_category(check, patternId) do
    #   ErrorProne, CodeStyle, UnusedCode, Security, Compatibility, Performance, Documentation

    isSecurity = Map.has_key?(@securityPatterns, patternId)

    case elem(check, 0).category do
      :warning when isSecurity -> {"Security", @securityPatterns[patternId]}
      :warning -> {"ErrorProne", nil}
      _ -> {"CodeStyle", nil}
    end
  end

  @doc """
  Convert Check to acceptable patternId

  ## Example
    iex> Codacy.Credo.Generator.Patterns.check_pattern_id({Credo.Check.Refactor.LongQuoteBlocks})
    "refactor_long_quote_blocks"
    iex> Codacy.Credo.Generator.Patterns.check_pattern_id({Credo.Check.Refactor.LongQuoteBlocks, [option: :options]})
    "refactor_long_quote_blocks"
  """
  @spec check_pattern_id({atom}) :: String.t()
  def check_pattern_id({check}) do
    check
    |> Atom.to_string()
    |> String.replace_leading("Elixir.Credo.Check.", "")
    |> String.replace(".", "")
    |> Macro.underscore()
  end

  def check_pattern_id({check, _}), do: check_pattern_id({check})
end
