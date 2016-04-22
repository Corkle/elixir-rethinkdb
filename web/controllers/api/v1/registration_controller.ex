defmodule RethinkExample.RegistrationController do
  use RethinkExample.Web, :controller
  
  alias RethinkDatabase, as: DB
  alias RethinkExample.User
  
  plug :scrub_params, "user" when action in [:create]
  
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    
    case DB.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        
        conn
        |> put_status(:created)
        |> render(RethinkExample.SessionView, "show.json", jsw: jwt, user: user)
        
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RethinkDatabase.RegistrationView, "error.json", changeset: changeset)
    end
  end
end