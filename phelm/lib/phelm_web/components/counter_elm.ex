defmodule PhelmWeb.CounterElm do
  @moduledoc false

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex flex-row items-stretch space-x-2" class="ElmCounter" phx-hook="ElmCounter" id={@id} />
    """
  end

  def mount(socket) do
    {:ok, assign(socket, count: 0)}
  end
end
