defmodule UndiWeb.Admin.SessionController do
  use UndiWeb, :controller

  import Undi.Admins.GenerateAdmin
  alias Undi.Admins
  alias Undi.Admins.Guardian

  plug UndiWeb.Plugs.RedirectAdmin when action in [:new, :create]

  def new(conn, _) do
    render(conn, "new.html", zero_admins?: zero_admins?())
  end

  def create(conn, %{"admin" => %{"email" => email, "password" => password}}) do
    Admins.Auth.authenticate_admin(email, password)
    |> login_reply(conn)
  end

  def create(conn, %{"admin" => %{"email" => email}}) do
    with true <- zero_admins?(),
         {:ok, email, password} <- generate_admin(email) do

          Admins.Auth.authenticate_admin(email, password)
          |> login_reply(conn, "Your password is: #{password}")
    else
       _ ->
        Admins.Auth.authenticate_admin(email, "Error creating admin")
        |> login_reply(conn)
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: ~p"/admin/sign_in")
  end

  defp login_reply({:ok, admin}, conn), do: login_reply({:ok, admin}, conn, "Welcome back!")

  defp login_reply({:error, reason}, conn), do: login_reply({:error, reason}, conn, nil)

  defp login_reply({:ok, admin}, conn, flash) do
    conn
    |> put_flash(:info, flash)
    |> Guardian.Plug.sign_in(admin, %{}, key: :admin)
    |> redirect(to: ~p"/admin")
  end

  defp login_reply({:error, reason}, conn, flash) do
    conn
    |> put_flash(:error, (flash || to_string(reason)))
    |> new(%{})
  end
end
