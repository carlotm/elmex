defmodule Mix.Tasks.Elmex.Vendorize do
  @moduledoc "Vendorize Elm support files"

  use Mix.Task

  require Logger

  def run(_) do
    Elmex.start()
    Elmex.vendorize()
    |> Enum.each(&Logger.info("Wrote: #{&1}"))
  end
end
