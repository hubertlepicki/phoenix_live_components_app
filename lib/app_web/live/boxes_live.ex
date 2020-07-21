defmodule AppWeb.BoxesLive do
  use Phoenix.LiveView
  import Ecto.Query, only: [from: 2]

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "boxes.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, boxes: App.Repo.all(boxes_query))}
  end

  def handle_info({:box_added, box}, socket) do
    new_socket =
      socket
      |> assign(:boxes, socket.assigns.boxes ++ [box])

    {:noreply, new_socket}
  end

  def handle_info({:box_deleted, box}, socket) do
    new_socket =
      socket
      |> assign(:boxes, socket.assigns.boxes |> Enum.filter(&(&1.id != box.id)))

    {:noreply, new_socket}
  end

  defp boxes_query do
    from b in App.Box, order_by: [asc: b.inserted_at]
  end
end
