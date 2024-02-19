defmodule Elmex do
  @moduledoc false
  @name __MODULE__
  @default_conf [
    base_dir: "assets/elm",
    output_dir: "../../priv/static/assets",
    compiler_options: "--debug",
    watching: false,
    apps: [elmex: "src/*.elm"]
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
    state = build_state(%{watching: true})
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [state.base_dir])
    FileSystem.subscribe(watcher_pid)
    {:ok, Map.put(state, :watcher_pid, watcher_pid)}
  end

  def init(_) do
    {:ok, build_state()}
  end

  def handle_call(:compile, _, state) do
    response = Enum.map(state.apps, &compile_app(&1, state))
    {:reply, response, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {_path, [:modified, :closed]}},
        %{watcher_pid: watcher_pid} = state
      ) do
    # if Path.extname(path) == ".elm" do
    #   compile_file(path, state)
    # end

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

  defp compile_app({app_name, glob}, state) do
    sources = fetch_source_files(state.base_dir, glob)
    bundle_app(app_name, sources, state)
  end

  defp bundle_app(app_name, sources, state) do
    output_filename = Atom.to_string(app_name) <> ".js"
    output_path = Path.join(state.output_dir, output_filename)

    {out, rc} =
      System.cmd("elm", ["make", state.compiler_options, "--output", output_path] ++ sources,
        cd: state.base_dir,
        stderr_to_stdout: state.watching
      )

    IO.puts(out)
    rc
  end

  defp build_state(extra \\ %{}) do
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
    |> Enum.map(&Path.relative_to(&1, base_dir))
  end
end
