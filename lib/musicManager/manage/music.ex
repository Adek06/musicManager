defmodule MusicManager.Manage.Music do
  use Ecto.Schema
  import Ecto.Changeset

  schema "musics" do
    field :title, :string
    field :filePath, :string
    field :year, :integer, default: 999
    field :genre, :string, default: "未知"
    belongs_to :album, MusicManager.Manage.Album
    belongs_to :artist, MusicManager.Manage.Artist
    timestamps()
  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:title, :filePath, :artist_id, :year, :genre, :album_id])
    |> validate_required([:title, :filePath])
    |> validate_inclusion(:year, 999..3000)
  end
end
