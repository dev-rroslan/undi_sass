defmodule UndiWeb.Emails do
  @moduledoc """
  This viewmodule is responsible for rendering the emails and the layouts
  for emails using the Phoenix.Swoosh library

  Can be used in the notifier by adding:

      use Phoenix.Swoosh, view: UndiWeb.Emails, layout: {UndiWeb.Emails, :layout}

  """
  use Phoenix.View,
    root: "lib/undi_web",
    namespace: UndiWeb

  use Phoenix.Component

  import UndiWeb.AppInfo
end
