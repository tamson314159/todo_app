defmodule TodoAppWeb.TaskLive.Show do
  use TodoAppWeb, :live_view

  alias TodoApp.Tasks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    task = Tasks.get_task!(id)
    current_account_id = socket.assigns.current_account.id

    if task.account_id == current_account_id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:task, Tasks.get_task!(id))}
    else
      {:noreply, redirect(socket, to: ~p"/")}
    end
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
end
