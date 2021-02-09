defmodule MusicManager.Repo.Migrations.MusicsAddArtistId do
  use Ecto.Migration

  def change do
    alter table(:musics) do
      add :artist_id, references(:artists)
    end
  end
end
