defmodule Mix.Tasks.Elm.Compile do
  @moduledoc "Compiles Elm assets"
  use Mix.Task

  def run(_) do
    Elmex.start()

    Elmex.compile()
    |> Enum.group_by(fn rc -> rc == 0 end)
    |> Enum.map(fn
      {true, l} -> "Success: #{length(l)}"
      {_, l} -> "Failed: #{length(l)}"
    end)
    |> Enum.join(" - ")
    |> then(fn out ->
      rc =
        case String.contains?(out, "Failed") do
          true -> {:shutdown, 1}
          _ -> :normal
        end

      IO.puts(out)
      exit(rc)
    end)
  end
end
