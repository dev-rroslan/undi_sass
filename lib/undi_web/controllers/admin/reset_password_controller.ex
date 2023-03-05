defmodule UndiWeb.Admin.ResetPasswordController do
  use UndiWeb, :controller

  alias Undi.{Admins, Admins.AdminNotifier, Mailer}

  plug UndiWeb.Plugs.RedirectAdmin

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"admin" => %{"email" => email}}) do
    if admin = Admins.get_admin_by_email(email) do
      token = Phoenix.Token.sign(UndiWeb.Endpoint, "admin_auth", admin.id)

      AdminNotifier.admin_login_link(%{email: email, url: url(~p"/admin/reset_password/#{token}")})
      |> Mailer.deliver()
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: ~p"/admin/reset_password")
  end

  def show(conn, %{"token" => token}) do
    case Phoenix.Token.verify(UndiWeb.Endpoint, "admin_auth", token, max_age: 600) do
      {:ok, id} ->
        admin = Admins.get_admin!(id)

        conn
        |> put_flash(:info, "Welcome back!")
        |> Admins.Guardian.Plug.sign_in(admin, %{}, key: :admin)
        |> redirect(to: ~p"/admin")

      _ ->
        conn
        |> put_flash(:error, "The link you clicked is no longer valid")
        |> redirect(to: ~p"/admin/reset_password")
    end
  end
end
