defmodule DemoWeb.DemoLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="p-4 space-y-2">
      <h1 class="font-bold text-2xl">Elmex demo</h1>
      <p>Some Elm apps are rendered below to demostrate Elmex.</p>
      <h2 class="font-bold text-xl">Flags and ports</h2>
      <div
        phx-hook="Elmex"
        id="Flags"
        data-elm-app="Flags"
        data-flags="42"
        data-ports="true"
      />
      <p :if={@from_elm}>Elm says: <%= @from_elm %></p>
      <h2 class="font-bold text-xl">Counter</h2>
      <div phx-hook="Elmex" id="Counter" data-elm-app="Counter" />
      <h2 class="font-bold text-xl">Text reverse</h2>
      <div phx-hook="Elmex" id="TextReverse" data-elm-app="TextReverse" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, from_elm: nil)}
  end

  def handle_event("elmex", value, socket) do
    {:noreply, assign(socket, :from_elm, value)}
  end
end
