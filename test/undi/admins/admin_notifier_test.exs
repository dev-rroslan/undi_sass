defmodule Undi.Admins.AdminNotifierTest do
  use Undi.DataCase, async: true

  alias Undi.Admins.AdminNotifier

  test "admin login link email" do
    message = %{url: ~s(#somelinkwithtoken), email: "john.doe@example.com"}

    email = AdminNotifier.admin_login_link(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", "john.doe@undi.com"}
    assert email.html_body =~ "href=\"#somelinkwithtoken\""
  end
end
