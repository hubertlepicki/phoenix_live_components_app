defmodule AppWeb.BoxesLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "boxes.html", assigns)
  end
end
