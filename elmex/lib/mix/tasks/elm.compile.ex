defmodule Mix.Tasks.Elm.Compile do
  @moduledoc "Compiles Elm assets"
  use Mix.Task

  def run(_) do
    Elmex.start()
    Elmex.compile() |> IO.puts()
  end
end
