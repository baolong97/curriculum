defmodule HelloWorldWeb.PageController do
  use HelloWorldWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def hello_world(conn, _params) do
    render(conn, :hello_world, layout: false)
  end
end
