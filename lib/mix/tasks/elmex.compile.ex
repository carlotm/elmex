defmodule Mix.Tasks.Elmex.Compile do
  @moduledoc "Compiles Elm assets"

  use Mix.Task

  @spec run(list()) :: no_return()
  def run(_) do
    Elmex.start()
    Elmex.compile()
    |> Enum.all?(& &1 == 0)
    |> then(fn
      (true) -> exit(:normal)
      (false) -> exit({:shutdown, 1})
    end)
  end
end
