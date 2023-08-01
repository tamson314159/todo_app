defmodule TodoAppWeb.TaskLive.Index do
  use TodoAppWeb, :live_view

  alias TodoApp.Tasks
  alias TodoApp.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    tasks =
      socket.assigns.current_account.id
      |> Tasks.list_tasks_by_account_id()
      |> Enum.group_by(fn task -> task.completed end)

    {:ok,
      socket
      |> stream(:completed_tasks, Map.get(tasks, true, []))
      |> stream(:incomplete_tasks, Map.get(tasks, false, []))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({TodoAppWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :incomplete_tasks, task)}
  end

  @impl true
  def handle_event("completed", %{"task_id" => task_id}, socket) do
    task = Tasks.get_task!(task_id)
    switch_completed(socket, task, task.completed)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    stream_name = if task.completed, do: :completed_tasks, else: :incomplete_tasks

    {:noreply, stream_delete(socket, stream_name, task)}
  end

  defp switch_completed(socket, task, true) do
    case Tasks.update_task(task, %{"completed" => false}) do
      {:ok, task} ->
        {:noreply,
          socket
          |> stream_delete(:completed_tasks, task)
          |> stream_insert(:incomplete_tasks, task)
          |> put_flash(:info, "Updated task successfully")
        }

      _ -> {:noreply, socket}
    end
  end

  defp switch_completed(socket, task, false) do
    case Tasks.update_task(task, %{"completed" => true}) do
      {:ok, task} ->
        {:noreply,
          socket
          |> stream_delete(:incomplete_tasks, task)
          |> stream_insert(:completed_tasks, task)
          |> put_flash(:info, "Updated task successfully")
        }

      _ -> {:noreply, socket}
    end
  end
end
