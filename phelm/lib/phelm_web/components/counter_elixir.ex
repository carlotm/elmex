defmodule PhelmWeb.CounterElixir do
  @moduledoc false

  use Phoenix.LiveComponent

  import PhelmWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div class="flex flex-row items-stretch space-x-2">
      <button
        class="border border-brand bg-brand/5 p-2 rounded w-12"
        phx-click="inc"
        phx-target={@myself}
      >
        <.icon name="hero-plus" />
      </button>
      <code class="w-12 flex items-center justify-center bg-gray-200 border border-gray-400 rounded">
        <%= @count %>
      </code>
      <button
        class="border border-brand bg-brand/5 p-2 rounded w-12"
        phx-click="dec"
        phx-target={@myself}
      >
        <.icon name="hero-minus" />
      </button>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  def handle_event("dec", _, socket) do
    {:noreply, assign(socket, count: socket.assigns.count - 1)}
  end
end
