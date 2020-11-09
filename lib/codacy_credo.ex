defmodule Codacy.Credo do
  alias Codacy.Credo.Config
  alias Codacy.Credo.Runner
  alias Codacy.Credo.Output
  alias Credo.Execution
  alias Credo.Execution.ExecutionConfigFiles
  alias Credo.Execution.ExecutionSourceFiles
  alias Credo.Execution.ExecutionIssues
  alias Credo.Execution.ExecutionTiming
  alias Credo.Execution.Task.ParseOptions
  alias Credo.Execution.Task.ConvertCLIOptionsToConfig
  alias Credo.Execution.Task.DetermineCommand

  require Logger
  use Application

  def start(_type, _args) do
    # I'm Just a fancy Script that starts Credo with the prescribed startup settings
    Credo.Application.start(nil, nil)

    Config.srcPath()
    |> Config.load_config()
    |> Config.extract_credo_config()
    |> Config.write_codacy_config()
    |> run()

    System.stop(0)

    {:ok, self()}
  end

  def run(%Config{codacy_config: :use_default} = config) do
    File.cd(config.path)

    []
    |> Execution.build()
    |> init_execution_tasks()
    |> executeCredo()
  end

  def run(%Config{credo_config: credo_config} = config) do
    File.cd(config.path)

    struct(Execution, credo_config)
    |> ExecutionConfigFiles.start_server()
    |> ExecutionSourceFiles.start_server()
    |> ExecutionIssues.start_server()
    |> ExecutionTiming.start_server()
    |> executeCredo()
  end

  defp executeCredo(exec) do
    %Execution{exec | max_concurrent_check_runs: System.schedulers_online()}
    |> Runner.run()
    |> Output.print_results()
  end

  defp init_execution_tasks(exec) do
    exec
    |> ParseOptions.call(nil)
    |> ConvertCLIOptionsToConfig.call(nil)
    |> DetermineCommand.call(nil)
  end
end
