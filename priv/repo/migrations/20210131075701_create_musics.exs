defmodule MusicManager.Repo.Migrations.CreateMusics do
  use Ecto.Migration

  def change do
    create table(:musics) do
      add :title, :string
      add :filePath, :string
      add :year, :integer
      add :genre, :string

      timestamps()
    end

  end
end
