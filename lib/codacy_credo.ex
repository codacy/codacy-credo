defmodule Codacy.Credo do
  alias Codacy.Credo.Config
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
    |> Credo.Execution.build()
    |> init_execution_tasks()
    |> start()
  end

  def run(%Config{credo_config: credo_config} = config) do
    File.cd(config.path)

    struct(Credo.Execution, credo_config)
    |> Credo.Execution.ExecutionConfigFiles.start_server()
    |> Credo.Execution.ExecutionSourceFiles.start_server()
    |> Credo.Execution.ExecutionIssues.start_server()
    |> Credo.Execution.ExecutionTiming.start_server()
    |> init_execution_tasks()
    |> start()
  end

  defp start(exec) do
    exec
    |> Codacy.Credo.Runner.run()
    |> Codacy.Credo.Output.print_results()
  end

  defp init_execution_tasks(exec) do
    exec
    |> Credo.Execution.Task.ParseOptions.call(nil)
    |> Credo.Execution.Task.ConvertCLIOptionsToConfig.call(nil)
    |> Credo.Execution.Task.DetermineCommand.call(nil)
  end
end
