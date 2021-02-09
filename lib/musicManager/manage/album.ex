defmodule MusicManager.Manage.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :title, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:title, :year])
    |> validate_required([:title, :year])
  end
end
