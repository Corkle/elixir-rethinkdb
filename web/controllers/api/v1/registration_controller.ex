defmodule RethinkExample.RegistrationController do
  use RethinkExample.Web, :controller
  
  alias RethinkDatabase, as: DB
  alias RethinkExample.User
  
  
  plug :scrub_params, "user" when action in [:create]
  
  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end
  
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    
    case DB.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
        
        conn
        #|> put_flash(:info, "Successfully registered and logged in")
        #|> put_session(:current_user, changeset)
        #|> redirect(to: page_path(conn, :index))
        |> put_status(:created)
        |> render(RethinkExample.SessionView, "show.json", jwt: jwt, user: user)
        
      {:error, changeset} ->
        conn
        #|> render "new.html", changeset: changeset
        |> put_status(:unprocessable_entity)
        |> render(RethinkExample.RegistrationView, "error.json", changeset: changeset)
    end
  end
end