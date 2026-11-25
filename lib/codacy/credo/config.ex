defmodule Codacy.Credo.Config do
  alias Credo.ConfigFile
  alias Credo.Execution
  alias Credo.Execution.Task.AppendDefaultConfig
  alias Codacy.Credo.Generator.Patterns

  defstruct path: nil,
            codacy_config: nil,
            patterns: nil,
            credo_config: %{}

  @credoConfigFile ".credo.exs"

  def codacy_json_exists?() do
    File.exists?(codacyConfFilePath())
  end

  @doc """
  Load & decode .codacy.json
  """
  def parse_codacy_json(config) do
    with {:ok, file} <- File.read(codacyConfFilePath()),
         {:ok, json} <- Poison.decode(file, keys: :atoms!) do
      %__MODULE__{config | codacy_config: json}
    else
      {:error, error} ->
        raise inspect(error)
    end
  end

  def load_config(path) do
    config = %__MODULE__{path: path}

    case codacy_json_exists?() do
      true -> parse_codacy_json(config)
      false -> %__MODULE__{config | codacy_config: :use_default}
    end
  end

  def extract_credo_config(%__MODULE__{codacy_config: :use_default} = config) do
    # Add default configuration if src folder doesn't have config
    if !File.exists?(srcConfigPath()) do
      File.cp!(defaultConfigFilePath(), srcConfigPath())
    end

    config
  end

  def extract_credo_config(%__MODULE__{codacy_config: codacy} = config) do
    patterns = get_patterns(codacy)
    {checks, strict} = extract_checks(patterns)

    credo_config = %{
      name: "default",
      files: %{
        included: codacy.files,
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      strict: strict,
      min_priority: if(strict, do: -99, else: 0),
      checks: checks
    }

    config = %__MODULE__{config | credo_config: credo_config}
    %__MODULE__{config | patterns: patterns}
  end

  def config_or_default(path) do
    configFile =
      if File.exists?(defaultConfigFilePath()),
        do: defaultConfigFilePath(),
        else: Path.join(File.cwd!(), ".credo.default.exs")

    ConfigFile.read_from_file_path(Execution.build(), path, configFile)
  end

  defp get_patterns(%{tools: tools}) do
    tools
    |> Enum.find(fn tool -> tool.name == "credo" end)
    |> Map.get(:patterns)
  end

  defp extract_checks(nil) do
    Execution.build()
    |> AppendDefaultConfig.call([])
    |> ConfigFile.read_or_default(srcPath())
    |> case do
      {:ok, config} ->
        {config.checks, config.strict == true}

      {:error, errorMsg} ->
        raise inspect(errorMsg)
    end
  end

  defp extract_checks(patterns) do
    patterns_map = Patterns.pattern_id_map()

    enabled = Enum.map(patterns, &transform_pattern_to_check(&1, patterns_map))

    {%{enabled: enabled, disabled: []}, true}
  end

  def defaultConfigPath do
    "/opt/app/codacy_credo/"
  end

  def configurationDir() do
    "/opt/app/configuration"
  end

  def defaultConfigFilePath do
    Path.join(defaultConfigPath(), @credoConfigFile)
  end

  def srcConfigPath do
    Path.join(srcPath(), @credoConfigFile)
  end

  def srcPath do
    "/src/"
  end

  def codacyConfFilePath do
    "/.codacyrc"
  end

  defp transform_pattern_to_check(%{patternId: pattern_id, parameters: parameters}, patterns_map)
       when length(parameters) > 0 do
    check = patterns_map[pattern_id]

    {
      check,
      Enum.map(parameters, &parameters_to_check_params(&1, check))
    }
  end

  defp transform_pattern_to_check(%{patternId: pattern_id}, patterns_map) do
    {patterns_map[pattern_id], []}
  end

  def parameters_to_check_params(%{name: name, value: value}, check) do
    key = String.to_atom(name)

    {key, coerce_param(value, Keyword.get(check.param_defaults(), key))}
  end

  defp coerce_param(value, default) when is_list(value) and is_list(default),
    do: Enum.map(value, &coerce_list_item(&1, default))

  defp coerce_param(value, default), do: coerce_value(value, default)

  defp coerce_list_item("Elixir." <> _ = value, defaults) do
    if Enum.any?(defaults, &is_atom/1), do: String.to_atom(value), else: value
  end

  defp coerce_list_item(value, defaults) when is_binary(value) do
    cond do
      Enum.any?(defaults, &match?(%Regex{}, &1)) -> coerce_value(value, ~r//)
      defaults != [] and Enum.all?(defaults, &is_atom/1) -> String.to_atom(value)
      true -> value
    end
  end

  defp coerce_list_item(value, _defaults), do: value

  defp coerce_value(value, %Regex{}) when is_binary(value) do
    case Regex.compile(value) do
      {:ok, regex} -> regex
      {:error, _} -> value
    end
  end

  defp coerce_value(value, default)
       when is_binary(value) and is_atom(default) and not is_boolean(default) and
              not is_nil(default),
       do: String.to_atom(value)

  defp coerce_value(value, _default), do: value

  def write_codacy_config(%__MODULE__{codacy_config: :use_default} = config), do: config

  def write_codacy_config(%__MODULE__{credo_config: credo_config} = config) do
    # Write codacy's configuration if exists patterns
    if !is_nil(config.patterns) do
      write_config(credo_config)
    end

    config
  end

  defp write_config(credo_config) do
    tmpFilePath = Path.join(configurationDir(), "elixir.tmp")
    configFilePath = Path.join(configurationDir(), @credoConfigFile)

    # write the configuration struct into a temp file using inspect
    tmpFile = File.open!(tmpFilePath, [:read, :utf8, :write])
    IO.inspect(tmpFile, credo_config, [])

    # generate the configuration file
    content = File.read!(tmpFilePath)
    File.write!(configFilePath, "%{
      configs: [
        #{content}
      ]}")

    File.close(tmpFile)
    File.rm!(tmpFilePath)
  end
end
