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
    file = music_params["musicFile"]
    file_store_path = "priv/static/music/#{file.filename}"
    File.cp(file.path, file_store_path)

    id3_tags = ID3v2.parse(file.path)
    version = Map.get(id3_tags, "version")
    {album_title, year} = case version do
      2 ->
        album_title = if Map.get(id3_tags, "TAL"), do: id3_tags["TAL"], else: "未知"
        year = if Map.get(id3_tags, "TDR"), do: id3_tags["TDR"], else: 999
        {album_title, year}
      _ ->
        album_title = if Map.get(id3_tags, "TALB"), do: id3_tags["TALB"], else: "未知"
        year = if Map.get(id3_tags, "TDRC"), do: id3_tags["TDRC"], else: 999
        {album_title, year}
    end

    album = Manage.get_album_by_name(album_title)
    album_id = if album == nil do
      album_id = case Manage.create_album(%{:title => album_title, :year => year}) do
                   {:ok, album} ->
                     album.id
                   {:error, %Ecto.Changeset{} = changeset} ->
                     render(conn, "new.html", changeset: changeset)
                 end
      album_id
    else
      album.id
    end

    artist_name = if Map.get(id3_tags, "TPE1"), do: id3_tags["TPE1"], else: "未知"
    artist = Manage.get_artist_by_name(artist_name)
    artist_id = if artist == nil do
      artist_id = case Manage.create_artist(%{:name => artist_name}) do
                   {:ok, artist} ->
                     artist.id
                   {:error, %Ecto.Changeset{} = changeset} ->
                     render(conn, "new.html", changeset: changeset)
                 end
      artist_id
    else
      artist.id
    end

    # {:ok, content} = File.read(file.path)
    # Aliyun.Oss.Object.put_object("adek06game", file.filename, content)
    music = %{:title => file.filename, :filePath => file_store_path, :album_id => album_id, :artist_id => artist_id}
    case Manage.create_music(music) do
      {:ok, music} ->
        conn
        |> put_flash(:info, "Music created successfully.")
        |> redirect(to: Routes.music_path(conn, :show, music))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    music = Manage.get_music(id)
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
