defmodule DemoWeb.DemoLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="p-4 space-y-2">
      <h1 class="font-bold text-2xl">Elmex demo</h1>
      <p>A couple of Elm apps are rendered below to demostrate Elmex.</p>
      <h2 class="font-bold text-xl">Counter</h2>
      <div phx-hook="Elmex" id="Counter" data-elm-app="Counter" />
      <h2 class="font-bold text-xl">Text reverse</h2>
      <div phx-hook="Elmex" id="TextReverse" data-elm-app="TextReverse" />
    </div>
    """
  end
end
