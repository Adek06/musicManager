defmodule MusicManager.Repo.Migrations.MusicBelongsToAlbum do
  use Ecto.Migration

  def change do
    alter table(:musics) do
      add :album_id, references(:albums)
    end
  end
end
