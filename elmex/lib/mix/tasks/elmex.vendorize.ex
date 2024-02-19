defmodule Mix.Tasks.Elmex.Vendorize do
  @moduledoc "Vendorize the elmex hook"

  use Mix.Task

  require Logger

  def run(_) do
    :code.priv_dir(:elmex)
    |> Path.join("elmex_hook.js")
    |> File.copy("assets/vendor/elmex_hook.js")
  end
end
