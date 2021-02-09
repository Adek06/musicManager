defmodule MusicManager.ManageTest do
  use MusicManager.DataCase

  alias MusicManager.Manage

  describe "musics" do
    alias MusicManager.Manage.Music

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def music_fixture(attrs \\ %{}) do
      {:ok, music} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manage.create_music()

      music
    end

    test "list_musics/0 returns all musics" do
      music = music_fixture()
      assert Manage.list_musics() == [music]
    end

    test "get_music!/1 returns the music with given id" do
      music = music_fixture()
      assert Manage.get_music!(music.id) == music
    end

    test "create_music/1 with valid data creates a music" do
      assert {:ok, %Music{} = music} = Manage.create_music(@valid_attrs)
      assert music.name == "some name"
    end

    test "create_music/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manage.create_music(@invalid_attrs)
    end

    test "update_music/2 with valid data updates the music" do
      music = music_fixture()
      assert {:ok, %Music{} = music} = Manage.update_music(music, @update_attrs)
      assert music.name == "some updated name"
    end

    test "update_music/2 with invalid data returns error changeset" do
      music = music_fixture()
      assert {:error, %Ecto.Changeset{}} = Manage.update_music(music, @invalid_attrs)
      assert music == Manage.get_music!(music.id)
    end

    test "delete_music/1 deletes the music" do
      music = music_fixture()
      assert {:ok, %Music{}} = Manage.delete_music(music)
      assert_raise Ecto.NoResultsError, fn -> Manage.get_music!(music.id) end
    end

    test "change_music/1 returns a music changeset" do
      music = music_fixture()
      assert %Ecto.Changeset{} = Manage.change_music(music)
    end
  end

  describe "musics" do
    alias MusicManager.Manage.Music

    @valid_attrs %{file: "some file", name: "some name"}
    @update_attrs %{file: "some updated file", name: "some updated name"}
    @invalid_attrs %{file: nil, name: nil}

    def music_fixture(attrs \\ %{}) do
      {:ok, music} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manage.create_music()

      music
    end

    test "list_musics/0 returns all musics" do
      music = music_fixture()
      assert Manage.list_musics() == [music]
    end

    test "get_music!/1 returns the music with given id" do
      music = music_fixture()
      assert Manage.get_music!(music.id) == music
    end

    test "create_music/1 with valid data creates a music" do
      assert {:ok, %Music{} = music} = Manage.create_music(@valid_attrs)
      assert music.file == "some file"
      assert music.name == "some name"
    end

    test "create_music/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manage.create_music(@invalid_attrs)
    end

    test "update_music/2 with valid data updates the music" do
      music = music_fixture()
      assert {:ok, %Music{} = music} = Manage.update_music(music, @update_attrs)
      assert music.file == "some updated file"
      assert music.name == "some updated name"
    end

    test "update_music/2 with invalid data returns error changeset" do
      music = music_fixture()
      assert {:error, %Ecto.Changeset{}} = Manage.update_music(music, @invalid_attrs)
      assert music == Manage.get_music!(music.id)
    end

    test "delete_music/1 deletes the music" do
      music = music_fixture()
      assert {:ok, %Music{}} = Manage.delete_music(music)
      assert_raise Ecto.NoResultsError, fn -> Manage.get_music!(music.id) end
    end

    test "change_music/1 returns a music changeset" do
      music = music_fixture()
      assert %Ecto.Changeset{} = Manage.change_music(music)
    end
  end

  describe "albums" do
    alias MusicManager.Manage.Album

    @valid_attrs %{title: "some title", year: 42}
    @update_attrs %{title: "some updated title", year: 43}
    @invalid_attrs %{title: nil, year: nil}

    def album_fixture(attrs \\ %{}) do
      {:ok, album} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manage.create_album()

      album
    end

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Manage.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Manage.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Manage.create_album(@valid_attrs)
      assert album.title == "some title"
      assert album.year == 42
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manage.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      assert {:ok, %Album{} = album} = Manage.update_album(album, @update_attrs)
      assert album.title == "some updated title"
      assert album.year == 43
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Manage.update_album(album, @invalid_attrs)
      assert album == Manage.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Manage.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Manage.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Manage.change_album(album)
    end
  end

  describe "artists" do
    alias MusicManager.Manage.Artist

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manage.create_artist()

      artist
    end

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Manage.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Manage.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Manage.create_artist(@valid_attrs)
      assert artist.name == "some name"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manage.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{} = artist} = Manage.update_artist(artist, @update_attrs)
      assert artist.name == "some updated name"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Manage.update_artist(artist, @invalid_attrs)
      assert artist == Manage.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Manage.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Manage.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Manage.change_artist(artist)
    end
  end
end
