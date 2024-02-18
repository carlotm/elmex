defmodule DemoWeb.DemoLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <h1>Some Elm apps</h1>
    <p>A couple of Elm apps are rendered below to demostrate Elmex.</p>
    <h2>Counter</h2>
    <div phx-hook="Elmex" id="Counter" data-elm-app="Counter" />
    <h2>Text reverse</h2>
    <div phx-hook="Elmex" id="TextReverse" data-elm-app="TextReverse" />
    """
  end
end
