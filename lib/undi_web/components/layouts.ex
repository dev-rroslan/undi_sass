defmodule UndiWeb.Layouts do
  @moduledoc false
  use UndiWeb, :html

  import UndiWeb.LayoutComponents
  import UndiWeb.Components.Dropdowns, only: [dropdown: 1]

  embed_templates "layouts/*"

  attr :navigate, :string
  attr :mobile, :boolean, default: false
  attr :label, :string, required: true
  attr :rest, :global, include: ~w(method)
  slot :inner_block, required: true
  def admin_nav_link(%{mobile: true} = assigns) do
    ~H"""
    <.link navigate={@navigate} {@rest} class="flex items-center p-2 text-base font-medium text-base-content text-opacity-80 group rounded-md hover:text-opacity-100">
      <%= render_slot(@inner_block) %>
      <%= @label %>
    </.link>
    """
  end

  def admin_nav_link(assigns) do
    ~H"""
    <.link navigate={@navigate} {@rest} data-tooltip={@label} class="flex items-center p-2 rounded-lg text-base-content text-opacity-70 hover:text-opacity-100">
      <%= render_slot(@inner_block) %>
      <span class="sr-only"><%= @label %></span>
    </.link>
    """
  end
end
