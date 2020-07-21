defmodule AppWeb.BoxComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "box_component.html", assigns)
  end

  def update(%{box: box}, socket) do
    {:ok, assign(socket, box: box)}
  end

  def handle_event("delete_box", _, socket) do
    App.Repo.delete(socket.assigns.box)

    send(self(), {:box_deleted, socket.assigns.box})
    {:noreply, socket}
  end
end
