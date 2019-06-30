defmodule MessageProcessorWeb.Router do
  use MessageProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MessageProcessorWeb do
    pipe_through :api
  end
end
