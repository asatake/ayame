defmodule AyameWeb.PageController do
  use AyameWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
