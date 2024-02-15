defmodule PhelmWeb.Counter do
  @moduledoc false

  use Phoenix.LiveComponent

  import PhelmWeb.CoreComponents

  attr :from, :integer, default: 0

  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <button class="border border-brand bg-brand/5 p-2 rounded w-12">
        <.icon name="hero-plus" />
      </button>
      <code class="w-12 text-center"><%= @from %></code>
      <button class="border border-brand bg-brand/5 p-2 rounded w-12">
        <.icon name="hero-minus" />
      </button>
    </div>
    """
  end
end
