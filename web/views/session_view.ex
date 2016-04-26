defmodule RethinkExample.SessionView do
  use RethinkExample.Web, :view
  
  def render("show.json", %{jwt: jwt, user: user}) do
    %{
      jwt: jwt,
      user: user
    }
  end
  
  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end
end