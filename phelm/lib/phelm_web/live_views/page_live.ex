defmodule PhelmWeb.PageLive do

  use Phoenix.LiveView

  import PhelmWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div class="p-4 space-y-4">
      <.live_component id="counter-elixir" module={PhelmWeb.CounterElixir} />
      <.live_component id="counter-elm" module={PhelmWeb.CounterElm} />
    </div>
    """
  end
end
