defmodule DemoWeb.DemoLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="p-4 space-y-2">
      <h1 class="font-bold text-2xl">Elmex demo</h1>
      <p class="rounded p-2 bg-slate-200" :if={@from_elm}>Elm says: <%= @from_elm %></p>
      <p>Some Elm apps are rendered below to demostrate Elmex.</p>
      <h2 class="font-bold text-xl">Flags and ports</h2>
      <div
        phx-hook="Elmex"
        id="Flags"
        data-elm-app="Flags"
        data-flags="42"
        data-ports="true"
      />
      <h2 class="font-bold text-xl">Counter</h2>
      <div phx-hook="Elmex" id="Counter" data-elm-app="Counter" />
      <h2 class="font-bold text-xl">Text reverse</h2>
      <div phx-hook="Elmex" id="TextReverse" data-elm-app="TextReverse" />
      <button
        class="p-2 bg-yellow-200 rounded"
        phx-click="talk-to-elm"
        value="Elm is cool"
      >
        Click me!!!
      </button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, from_elm: nil)}
  end

  def handle_event("elmex", value, socket) do
    {:noreply, assign(socket, :from_elm, value)}
  end

  def handle_event("talk-to-elm", payload, socket) do
    {:noreply, push_event(socket, "elmex", payload)}
  end
end
