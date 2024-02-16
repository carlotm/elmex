defmodule Elmex do
  @moduledoc false
  @name __MODULE__

  use GenServer

  #########################################################
  # API
  #########################################################

  def start() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def compile() do
    GenServer.call(@name, :compile)
  end

  #########################################################
  # Server callbacks
  #########################################################

  def init(_) do
    user_conf = Application.get_all_env(:elmex)
    conf = Keyword.merge(default_conf(), user_conf)

    source_files =
      Keyword.get(conf, :base_dir)
      |> Path.join(Keyword.get(conf, :sources))
      |> Path.wildcard()

    {:ok, %{conf: conf, source_files: source_files}}
  end

  def handle_call(:compile, _, %{conf: conf, source_files: source_files} = state) do
    response =
      source_files
      |> Enum.map(fn f ->
        {out, _} = compile_file(f, conf)
        out
      end)
      |> Enum.join("\n")

    {:reply, response, state}
  end

  #########################################################
  # Helpers
  #########################################################

  defp default_conf do
    [
      base_dir: "assets/elm",
      sources: "./src/*.elm",
      output: "../../priv/static/assets",
      compiler_options: "--debug",
      watch: false
    ]
  end

  defp compile_file(path, conf) do
    compiler_options = Keyword.get(conf, :compiler_options)
    base_dir = Keyword.get(conf, :base_dir)
    input_file = Path.relative_to(path, base_dir)
    output_filename = Path.basename(path, ".elm") <> ".js"
    output_file = Path.join(Keyword.get(conf, :output), output_filename)

    System.cmd("elm", ["make", compiler_options, input_file, "--output", output_file],
      cd: base_dir
    )
  end
end
