defmodule UndiWeb.Admin.AdminLive.Show do
  @moduledoc """
  The admin admin show page.
  """
  use UndiWeb, :live_view

  import UndiWeb.Live.Admin.LiveHelpers
  import UndiWeb.Components.Cards, only: [card: 1]

  alias Undi.Admins

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    admin = Admins.get_admin!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:admin, admin)}
  end

  defp page_title(:show), do: "Show Admin"
  defp page_title(:edit), do: "Edit Admin"
end
