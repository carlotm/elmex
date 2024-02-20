defmodule Mix.Tasks.Elmex.Vendorize do
  @moduledoc "Vendorize the elmex hook"

  use Mix.Task

  require Logger

  @requirements ["app.config"]
  @switches [
    js_path: :string,
    elm_path: :string
  ]
  @default [
    js_path: "assets/vendor",
    elm_path: "assets/elm/src/LiveView"
  ]

  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches)
    [js_path: js_path, elm_path: elm_path] = Keyword.merge(@default, opts)

    File.mkdir(js_path)
    Logger.info("Created: #{js_path}")

    js_hook_file = Path.join(js_path, "elmex_hook.js")

    :code.priv_dir(:elmex)
    |> Path.join("elmex_hook.js")
    |> File.copy(js_hook_file)

    Logger.info("Wrote: #{js_hook_file}")

    File.mkdir(elm_path)
    Logger.info("Created: #{elm_path}")

    elm_ports_file = Path.join(elm_path, "Utils.elm")

    :code.priv_dir(:elmex)
    |> Path.join("LiveView/Utils.elm")
    |> File.copy(elm_ports_file)

    Logger.info("Wrote: #{elm_ports_file}")
  end
end
