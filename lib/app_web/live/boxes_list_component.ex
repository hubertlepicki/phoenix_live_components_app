defmodule AppWeb.BoxesListComponent do
  use Phoenix.LiveComponent
  import Ecto.Query, only: [from: 2]

  def render(assigns) do
    Phoenix.View.render(AppWeb.BoxesView, "boxes_list_component.html", assigns)
  end

  def mount(socket) do
    boxes = boxes_query() |> App.Repo.all() |> ensure_at_least_one_box()

    {:ok,
     assign(socket,
       boxes: boxes,
       empty_box_id: find_empty_box_id(boxes),
       new_thing_form_in_box: nil
     )}
  end

  def update(%{new_thing_form_in_box: box_id}, socket) do
    {:ok, assign(socket, new_thing_form_in_box: box_id)}
  end

  def update(%{thing_added: thing}, socket) do
    boxes = socket.assigns.boxes |> Enum.map(&maybe_add_thing(thing, &1))

    new_socket =
      socket
      |> assign(empty_box_id: find_empty_box_id(boxes), new_thing_form_in_box: nil, boxes: boxes)

    {:ok, new_socket}
  end

  def update(%{thing_updated: thing}, socket) do
    boxes = socket.assigns.boxes |> Enum.map(&maybe_update_thing(thing, &1))
    new_socket = socket |> assign(boxes: boxes)

    {:ok, new_socket}
  end

  def update(%{thing_deleted: thing}, socket) do
    boxes = socket.assigns.boxes |> Enum.map(&maybe_delete_thing(thing, &1))
    boxes = boxes |> remove_empty_boxes() |> ensure_at_least_one_box()

    new_socket =
      socket
      |> assign(empty_box_id: find_empty_box_id(boxes), new_thing_form_in_box: nil, boxes: boxes)

    {:ok, new_socket}
  end

  def update(%{box_deleted: box}, socket) do
    new_socket =
      socket
      |> assign(
        :boxes,
        socket.assigns.boxes |> Enum.filter(&(&1.id != box.id)) |> ensure_at_least_one_box()
      )

    {:ok, new_socket}
  end

  def update(%{id: _}, socket) do
    {:ok, socket}
  end

  defp maybe_delete_thing(%App.Thing{box_id: box_id} = thing, %App.Box{id: id} = box)
       when box_id == id do
    %{box | things: Enum.filter(box.things, &(&1.id != thing.id))}
  end

  defp maybe_delete_thing(_thing, box), do: box

  defp maybe_add_thing(%App.Thing{box_id: box_id} = thing, %App.Box{id: id} = box)
       when box_id == id do
    %{box | things: box.things ++ [thing]}
  end

  defp maybe_add_thing(_thing, box), do: box

  defp maybe_update_thing(%App.Thing{box_id: box_id} = thing, %App.Box{id: id} = box)
       when box_id == id do
    %{box | things: maybe_update_thing(thing, box.things)}
  end

  defp maybe_update_thing(%App.Thing{} = thing, things) when is_list(things) do
    things
    |> Enum.map(fn t ->
      if t.id == thing.id do
        thing
      else
        t
      end
    end)
  end

  defp maybe_update_thing(_thing, box), do: box

  def handle_event("add_box", _, socket) do
    box = App.Repo.insert!(%App.Box{}) |> Map.put(:things, [])

    {:noreply,
     socket
     |> assign(
       new_thing_form_in_box: nil,
       empty_box_id: box.id,
       boxes: socket.assigns.boxes ++ [box]
     )}
  end

  defp find_empty_box_id(boxes) do
    case Enum.find(boxes, &(&1.things == [])) do
      %App.Box{id: id} -> id
      _ -> nil
    end
  end

  defp boxes_query do
    from b in App.Box,
      order_by: [asc: b.inserted_at],
      preload: [
        things:
          ^from(
            t in App.Thing,
            order_by: [asc: t.inserted_at]
          )
      ]
  end

  defp ensure_at_least_one_box(boxes) do
    case boxes do
      [] -> [App.Repo.insert!(%App.Box{things: []})]
      boxes -> boxes
    end
  end

  defp remove_empty_boxes(boxes) do
    boxes
    |> Enum.map(&remove_box_if_empty(&1))
    |> Enum.filter(&(&1.things != []))
  end

  defp remove_box_if_empty(%{things: []} = box) do
    App.Repo.delete(box)
    box
  end

  defp remove_box_if_empty(box), do: box
end
