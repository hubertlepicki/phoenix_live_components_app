defmodule AppWeb.BoxComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "box_component.html", assigns)
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("delete_box", _, %{assigns: %{allow_delete: true}} = socket) do
    App.Repo.delete(socket.assigns.box)

    send_update(AppWeb.BoxesListComponent, id: "boxes_list", box_deleted: socket.assigns.box)
    {:noreply, socket}
  end
end
