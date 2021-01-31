defmodule MusicManager.Manage.Music do
  use Ecto.Schema
  import Ecto.Changeset

  schema "musics" do
    field :file, :binary
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:name, :file])
    |> validate_required([:name, :file])
  end
end
