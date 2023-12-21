defmodule HelloWorldWeb.NumberController do
  use HelloWorldWeb, :controller

  def random_number(conn, _params) do
    render(conn, :random_number, layout: false, number: Enum.random(1..100))
  end

  def count(conn, params) do
    number = String.to_integer(params["number"] || 0)
    render(conn, :count, layout: false, number: number)
  end
end
