defmodule MusicManagerWeb.ArtistController do
  use MusicManagerWeb, :controller

  alias MusicManager.Manage
  alias MusicManager.Manage.Artist

  def index(conn, _params) do
    artists = Manage.list_artists()
    render(conn, "index.html", artists: artists)
  end

  def new(conn, _params) do
    changeset = Manage.change_artist(%Artist{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"artist" => artist_params}) do
    case Manage.create_artist(artist_params) do
      {:ok, artist} ->
        conn
        |> put_flash(:info, "Artist created successfully.")
        |> redirect(to: Routes.artist_path(conn, :show, artist))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    artist = Manage.get_artist!(id)
    render(conn, "show.html", artist: artist)
  end

  def edit(conn, %{"id" => id}) do
    artist = Manage.get_artist!(id)
    changeset = Manage.change_artist(artist)
    render(conn, "edit.html", artist: artist, changeset: changeset)
  end

  def update(conn, %{"id" => id, "artist" => artist_params}) do
    artist = Manage.get_artist!(id)

    case Manage.update_artist(artist, artist_params) do
      {:ok, artist} ->
        conn
        |> put_flash(:info, "Artist updated successfully.")
        |> redirect(to: Routes.artist_path(conn, :show, artist))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", artist: artist, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    artist = Manage.get_artist!(id)
    {:ok, _artist} = Manage.delete_artist(artist)

    conn
    |> put_flash(:info, "Artist deleted successfully.")
    |> redirect(to: Routes.artist_path(conn, :index))
  end
end
