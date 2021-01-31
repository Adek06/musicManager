defmodule MusicManagerWeb.MusicController do
  use MusicManagerWeb, :controller

  alias MusicManager.Manage
  alias MusicManager.Manage.Music

  def index(conn, _params) do
    musics = Manage.list_musics()
    render(conn, "index.html", musics: musics)
  end

  def new(conn, _params) do
    changeset = Manage.change_music(%Music{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"music" => music_params}) do
    IO.inspect music_params     
    file = music_params["musicFile"]
    IO.inspect file.filename
    IO.inspect file.path
    {:ok, content} = File.read(file.path)
    Aliyun.Oss.Object.put_object("adek06game", file.filename, content)
    case Manage.create_music(music_params) do
      {:ok, music} ->
        conn
        |> put_flash(:info, "Music created successfully.")
        |> redirect(to: Routes.music_path(conn, :show, music))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    music = Manage.get_music!(id)
    render(conn, "show.html", music: music)
  end

  def edit(conn, %{"id" => id}) do
    music = Manage.get_music!(id)
    changeset = Manage.change_music(music)
    render(conn, "edit.html", music: music, changeset: changeset)
  end

  def update(conn, %{"id" => id, "music" => music_params}) do
    music = Manage.get_music!(id)

    case Manage.update_music(music, music_params) do
      {:ok, music} ->
        conn
        |> put_flash(:info, "Music updated successfully.")
        |> redirect(to: Routes.music_path(conn, :show, music))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", music: music, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    music = Manage.get_music!(id)
    {:ok, _music} = Manage.delete_music(music)

    conn
    |> put_flash(:info, "Music deleted successfully.")
    |> redirect(to: Routes.music_path(conn, :index))
  end
end
