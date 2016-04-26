defmodule RethinkExample.Session do
  use RethinkExample.Web, :model

  alias RethinkExample.User
  alias RethinkDatabase, as: DB
  
  def changeset(model, params \\ :empty) do
    model
  end
  
  def authenticate(%{"email" => email, "password" => password}) do
    user = DB.get_by(User, email: String.downcase(email))
    
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end
  
  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end
end