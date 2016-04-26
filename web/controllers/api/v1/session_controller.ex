defmodule RethinkExample.SessionController do
  use RethinkExample.Web, :controller
  
  alias RethinkExample.Post
  
  plug :scrub_params, "session" when action in [:create]
  
  def new(conn, _params) do
    render conn, changeset: Post.changeset(%Post{})
  end
  
  def create(conn, %{"session" => session_params}) do
    case RethinkExample.Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
        
        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)
        
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end
  
  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(PhoenixTrello.SessionView, "forbidden.json", error: "Not Authenticated")
  end
end