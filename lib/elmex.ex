defmodule Elmex do
  @moduledoc false
  @name __MODULE__
  @default_conf [
    base_dir: "assets/elm",
    output_dir: "../../priv/static/assets",
    compiler_options: "--debug",
    apps: [elmex: "src/*.elm"],
    vendor_js_dir: "assets/vendor",
    vendor_elm_dir: "assets/elm/src"
  ]

  use GenServer

  #########################################################
  # API
  #########################################################

  def start(conf \\ %{})

  def start(:watch) do
    GenServer.start_link(__MODULE__, :watch, name: @name)
  end

  def start(conf) do
    GenServer.start_link(__MODULE__, conf, name: @name)
  end

  def compile() do
    GenServer.call(@name, :compile)
  end

  def conf() do
    GenServer.call(@name, :conf)
  end

  def vendorize() do
    GenServer.call(@name, :vendorize)
  end

  #########################################################
  # Server callbacks
  #########################################################

  def init(:watch) do
    state = build_state(%{watch: true})
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [state.base_dir])
    FileSystem.subscribe(watcher_pid)
    {:ok, Map.put(state, :watcher_pid, watcher_pid)}
  end

  def init(runtimeConf) do
    conf =
      runtimeConf
      |> Map.put_new(:watch, false)
      |> build_state()

    {:ok, conf}
  end

  def handle_call(:conf, _, state) do
    {:reply, state, state}
  end

  def handle_call(:compile, _, state) do
    response = Enum.map(state.apps, &compile_app(&1, state))
    {:reply, response, state}
  end

  def handle_call(
        :vendorize,
        _,
        %{vendor_elm_dir: vendor_elm_dir, vendor_js_dir: vendor_js_dir} = state
      ) do
    response =
      [
        {vendor_elm_dir, "Elmex.elm"},
        {vendor_js_dir, "elmex_hook.js"}
      ]
      |> Enum.map(fn {vendor_dir, vendor_file} ->
        File.mkdir_p!(vendor_dir)
        destination = Path.join(vendor_dir, vendor_file)

        :code.priv_dir(:elmex)
        |> Path.join(vendor_file)
        |> File.copy!(destination)

        destination
      end)

    {:reply, response, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, [:modified, :closed]}},
        %{watcher_pid: watcher_pid} = state
      ) do
    if Path.extname(path) == ".elm" do
      compile_apps(state)
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

  defp compile_apps(state) do
    Enum.each(state.apps, fn {app_name, glob} ->
      compile_app({app_name, glob}, state)
    end)
  end

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
        stderr_to_stdout: state.watch
      )

    IO.puts(out)
    rc
  end

  defp build_state(extra) do
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
    |> Enum.filter(fn path -> not String.contains?(path, "Elmex.elm") end)
    |> Enum.map(&Path.relative_to(&1, base_dir))
  end
end
