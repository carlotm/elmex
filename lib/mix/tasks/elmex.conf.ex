defmodule Mix.Tasks.Elmex.Conf do
  @moduledoc "Print current elmex configuration"

  use Mix.Task

  @spec run(list()) :: no_return()
  def run(_) do
    Elmex.start()
    Elmex.conf() |> IO.inspect()
  end
end
