defmodule Elmex do
  @moduledoc false
  @name __MODULE__
  @default_conf [
    base_dir: "assets/elm",
    sources: "./src/*.elm",
    output: "../../priv/static/assets",
    compiler_options: "--debug",
    watching: false
  ]

  use GenServer

  #########################################################
  # API
  #########################################################

  def start() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def start(:watch) do
    GenServer.start_link(__MODULE__, :watch, name: @name)
  end

  def compile() do
    GenServer.call(@name, :compile)
  end

  #########################################################
  # Server callbacks
  #########################################################

  def init(:watch) do
    conf = fetch_conf(%{watching: true})
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [conf.base_dir])
    FileSystem.subscribe(watcher_pid)
    {:ok, Map.put(conf, :watcher_pid, watcher_pid)}
  end

  def init(_) do
    {:ok, fetch_conf()}
  end

  def handle_call(:compile, _, state) do
    response =
      fetch_source_files(state.base_dir, state.sources)
      |> Enum.map(&compile_file(&1, state))

    {:reply, response, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, [:modified, :closed]}},
        %{watcher_pid: watcher_pid} = state
      ) do
    if Path.extname(path) == ".elm" do
      compile_file(path, state)
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, _}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  #########################################################
  # Helpers
  #########################################################

  defp compile_file(path, state) do
    input_file = Path.relative_to(path, state.base_dir)
    output_filename = Path.basename(path, ".elm") <> ".js"
    output_file = Path.join(state.output, output_filename)

    {out, rc} =
      System.cmd("elm", ["make", state.compiler_options, input_file, "--output", output_file],
        cd: state.base_dir,
        stderr_to_stdout: state.watching
      )

    IO.puts(out)
    rc
  end

  defp fetch_conf(extra \\ %{}) do
    user_conf = Application.get_all_env(:elmex)

    @default_conf
    |> Keyword.merge(user_conf)
    |> Enum.into(%{})
    |> Map.merge(extra)
  end

  defp fetch_source_files(base_dir, sources_glob) do
    base_dir
    |> Path.join(sources_glob)
    |> Path.wildcard()
  end
end
