defmodule AppWeb.EditThingFormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "edit_thing_form_component.html", assigns)
  end

  def update(%{thing: thing}, socket) do
    {:ok, assign(socket, %{thing: thing, changeset: App.Thing.changeset(thing, %{})})}
  end

  def handle_event("submit", %{"thing" => thing_params}, socket) do
    changeset =
      App.Thing.changeset(
        socket.assigns.thing,
        Map.put(thing_params, "box_id", socket.assigns.thing.box_id)
      )

    case App.Repo.update(changeset) do
      {:ok, thing} ->
        send_update(AppWeb.BoxesListComponent, id: "boxes_list", thing_updated: thing)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}
    end
  end

  def handle_event("delete", _, socket) do
    App.Repo.delete(socket.assigns.thing)
    send_update(AppWeb.BoxesListComponent, id: "boxes_list", thing_deleted: socket.assigns.thing)
    {:noreply, socket}
  end
end
