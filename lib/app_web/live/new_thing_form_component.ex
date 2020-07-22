defmodule AppWeb.NewThingFormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "new_thing_form_component.html", assigns)
  end

  def mount(socket) do
    {:ok, socket |> assign(:changeset, App.Thing.changeset(%App.Thing{}, %{}))}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("submit", %{"thing" => %{"type" => type, "name" => name}}, socket) do
    changeset =
      App.Thing.changeset(%App.Thing{}, %{type: type, name: name, box_id: socket.assigns.box_id})

    case App.Repo.insert(changeset) do
      {:ok, thing} ->
        send_update(AppWeb.BoxesListComponent, id: "boxes_list", thing_added: thing)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}
    end
  end

  def handle_event("submit", %{"thing" => %{"type" => type}}, socket) do
    new_socket = socket |> assign(:changeset, App.Thing.changeset(%App.Thing{}, %{type: type}))
    {:noreply, new_socket}
  end

  def handle_event("cancel", _, socket) do
    send_update(AppWeb.BoxesListComponent, id: "boxes_list", new_thing_form_in_box: nil)
    {:noreply, socket}
  end
end
