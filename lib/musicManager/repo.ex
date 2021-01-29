defmodule MusicManager.Repo do
  use Ecto.Repo,
    otp_app: :musicManager,
    adapter: Ecto.Adapters.Postgres
end
