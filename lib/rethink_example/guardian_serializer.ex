defmodule RethinkExample.GuardianSerializer do
  @behaviour Guardian.Serializier
  
  alias RethinkDatabase, as: DB
  alias RethinkExample.User
  
  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }
  
  def from_token("User:" <> id), do: { :ok, DB.get(User, String.to_integer(id)) }
  def from_token(_), do: { :error, "Unknown resource type" }
end