defmodule MusicManagerWeb.MusicController do
  use MusicManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, params) do  
    conn
    |> send_resp(201, "")
  end
  
end
