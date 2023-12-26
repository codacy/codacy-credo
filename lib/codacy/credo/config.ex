defmodule Codacy.Credo.Config do
  alias Credo.ConfigFile
  alias Credo.Execution
  alias Codacy.Credo.Generator.Patterns

  defstruct path: nil,
            codacy_config: nil,
            patterns: nil,
            credo_config: %{}

  @credoConfigFile ".credo.exs"

  defp find_config_recur(dir) do
    dir = String.replace(dir, "//", "/")

    Enum.flat_map(File.ls!(dir), fn file ->
      fname = "#{dir}/#{file}"

      if File.dir?(fname) && file != "docs" do
        find_config_recur(fname)
      else
        if file == @credoConfigFile do
          [dir]
        else
          []
        end
      end
    end)
  end

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

    credo_config = %{
      name: "default",
      files: %{
        included: codacy.files,
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      strict: true,
      min_priority: -99,
      checks: %{
        enabled: extract_checks(patterns),
        disabled: []
      }
    }

    config = %__MODULE__{config | credo_config: credo_config}
    %__MODULE__{config | patterns: patterns}
  end

  def config_or_default(path) do
    [configDir] = find_config_recur(path)

    ConfigFile.read_or_default(Execution.build(), configDir)
  end

  defp get_patterns(%{tools: tools}) do
    tools
    |> Enum.find(fn tool -> tool.name == "credo" end)
    |> Map.get(:patterns)
  end

  defp extract_checks(patterns) do
    patterns_map = Patterns.pattern_id_map()

    if is_nil(patterns) do
      ConfigFile.read_or_default(Execution.build(), srcPath())
      |> case do
        {:ok, config} ->
          # it is required to normalize checks.
          # the method that does that is private (normalize_check_tuples)
          # the only way of calling it is by calling this method.
          # The second param is required and must be a ConfigFile object.
          # ConfigFile.merge_checks(config, %ConfigFile{checks: nil})
          config.checks.enabled

        {:error, errorMsg} ->
          raise inspect(errorMsg)
      end
    else
      patterns
      |> Enum.map(&transform_pattern_to_check(&1, patterns_map))
    end
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
    {
      patterns_map[pattern_id],
      Enum.map(parameters, &parameters_to_check_params/1)
    }
  end

  defp transform_pattern_to_check(%{patternId: pattern_id}, patterns_map) do
    {patterns_map[pattern_id], []}
  end

  defp parameters_to_check_params(%{name: name, value: value}) do
    {
      name |> String.to_atom(),
      value
    }
  end

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
