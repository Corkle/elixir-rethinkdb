defmodule RethinkExample.UserController do
  use RethinkExample.Web, :controller

  alias RethinkExample.User
  alias RethinkDatabase, as: DB

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = DB.all(User)
    render(conn, "index.html", users: users)
  end

#  def new(conn, _params) do
#    changeset = User.changeset(%User{})
#    render(conn, "new.html", changeset: changeset)
#  end

#  def create(conn, %{"user" => user_params}) do
#    changeset = User.changeset(%User{}, user_params)
#
#    case DB.insert(changeset) do
#      {:ok, _user} ->
#        conn
#        |> put_flash(:info, "User created successfully.")
#        |> redirect(to: user_path(conn, :index))
#      {:error, changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
#  end

  def show(conn, %{"id" => id}) do
    user = DB.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = DB.get(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = DB.get(User, id)
    changeset = User.changeset(user, user_params)

    case DB.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = DB.get(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    DB.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
