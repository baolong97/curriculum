defmodule HelloWorldWeb.HelloWorldController do
  use HelloWorldWeb, :controller

  def home(conn, _params) do
    conn
    |> put_layout(html: {HelloWorldWeb.Layouts, :hello_world})
    |> render(:home, current_page: "home")
  end

  def about(conn, _params) do
    conn
    |> put_layout(html: {HelloWorldWeb.Layouts, :hello_world})
    |> render(:about, current_page: "about")
  end

  def projects(conn, _params) do
    conn
    |> put_layout(html: {HelloWorldWeb.Layouts, :hello_world})
    |> render(:projects, current_page: "projects")
  end
end
