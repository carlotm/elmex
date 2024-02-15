defmodule PhelmWeb.PageLive do

  use Phoenix.LiveView

  import PhelmWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div class="p-10">
      <.live_component id="counter-elixir" module={PhelmWeb.CounterElixir} />
    </div>
    """
  end
end
