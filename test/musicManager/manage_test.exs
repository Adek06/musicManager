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
end
