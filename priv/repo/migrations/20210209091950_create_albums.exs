defmodule MusicManager.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :title, :string
      add :year, :integer

      timestamps()
    end

  end
end
