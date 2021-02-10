defmodule MusicManager.Manage.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :title, :string
    field :year, :integer
    has_many :music, MusicManager.Manage.Music

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:title, :year])
    |> validate_required([:title, :year])
  end
end
