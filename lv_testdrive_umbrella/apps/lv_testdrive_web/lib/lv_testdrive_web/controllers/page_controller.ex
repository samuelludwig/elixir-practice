defmodule LvTestdriveWeb.PageController do
  use LvTestdriveWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, LvTestdriveWeb.GitubDeployView, session: %{})
  end
end
