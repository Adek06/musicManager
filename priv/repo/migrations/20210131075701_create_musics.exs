defmodule MusicManager.Repo.Migrations.CreateMusics do
  use Ecto.Migration

  def change do
    create table(:musics) do
      add :title, :string
      add :filePath, :string
      add :artist, :string
      add :album, :string
      add :year, :integer
      add :comment, :string
      add :zero_byte, :binary
      add :track, :binary
      add :genre, :string
      
      timestamps()
    end

  end
end
