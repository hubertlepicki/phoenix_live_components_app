defmodule AppWeb.BoxesListComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "boxes_list_component.html", assigns)
  end

  def update(%{boxes: boxes}, socket) do
    {:ok, assign(socket, boxes: boxes)}
  end

  def handle_event("add_box", _, socket) do
    box = App.Repo.insert!(%App.Box{})

    send(self(), {:box_added, box})
    {:noreply, socket}
  end
end
