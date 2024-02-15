defmodule PhelmWeb.PageLive do

  use Phoenix.LiveView

  import PhelmWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div class="p-10">
      <.live_component module={PhelmWeb.Counter} id="counter01" />
    </div>
    """
  end
end
