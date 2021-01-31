defmodule MusicManager.Repo.Migrations.CreateMusics do
  use Ecto.Migration

  def change do
    create table(:musics) do
      add :name, :string
      add :file, :binary

      timestamps()
    end

  end
end
