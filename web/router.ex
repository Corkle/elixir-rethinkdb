defmodule RethinkExample.Router do
  use RethinkExample.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", RethinkExample do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/posts", PostController
    
    get "/registration", RegistrationController, :new
    post "/registration", RegistrationController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api", RethinkExample do
    pipe_through :api
    
    scope "/v1" do
      post "/registrations", RegistrationController, :create
      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete
    end
  end
end
