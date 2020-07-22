defmodule AppWeb.ThingsListComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "things_list_component.html", assigns)
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_thing", _, socket) do
    send_update(AppWeb.BoxesListComponent,
      id: "boxes_list",
      new_thing_form_in_box: socket.assigns.box_id
    )

    {:noreply, socket}
  end
end
