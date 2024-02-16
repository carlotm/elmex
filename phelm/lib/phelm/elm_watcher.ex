defmodule Phelm.ElmWatcher do
  use GenServer

  @name __MODULE__

  # Public

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: @name)
  end

  def init(config) do
    IO.inspect(config)

    {:ok, watcher_pid} = FileSystem.start_link(dirs: [])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  ## Private

  def handle_info({:file_event, _, {file, [:modified, :closed]}}, state) do
    if String.ends_with?(file, ".elm") do
      GenServer.cast(@name, {:compile, file})
    end
    {:noreply, state}
  end

  def handle_info({:file_event, _, :stop}, state) do
    {:noreply, state}
  end

  def handle_info({:file_event, _, _}, state) do
    {:noreply, state}
  end

  def handle_cast({:compile, file}, state) when is_binary(file) do
    IO.inspect(">>>COMPILE>>>")
    IO.inspect(file)
    IO.inspect(">>>COMPILE>>>")
    {:noreply, state}
  end
end
