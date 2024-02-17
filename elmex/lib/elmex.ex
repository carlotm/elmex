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

    conf =
      default_conf()
      |> Keyword.merge(user_conf)
      |> Enum.into(%{})

    state =
      Map.put(
        conf,
        :source_files,
        conf.base_dir
        |> Path.join(conf.sources)
        |> Path.wildcard()
      )

    {:ok, state}
  end

  def handle_call(
        :compile,
        _,
        %{
          base_dir: base_dir,
          compiler_options: compiler_options,
          output: output,
          source_files: source_files
        } = state
      ) do
    response =
      source_files
      |> Enum.map(fn f ->
        {out, exit_code} = compile_file(f, base_dir, compiler_options, output)
        IO.puts(out)
        exit_code
      end)

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

  defp compile_file(path, base_dir, compiler_options, output) do
    input_file = Path.relative_to(path, base_dir)
    output_filename = Path.basename(path, ".elm") <> ".js"
    output_file = Path.join(output, output_filename)

    System.cmd("elm", ["make", compiler_options, input_file, "--output", output_file],
      cd: base_dir
    )
  end
end
