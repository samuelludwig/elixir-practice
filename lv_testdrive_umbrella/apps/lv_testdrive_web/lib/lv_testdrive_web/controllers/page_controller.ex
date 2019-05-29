defmodule LvTestdriveWeb.PageController do
  use LvTestdriveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
