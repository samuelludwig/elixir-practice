defmodule LvTestdrive.Repo do
  use Ecto.Repo,
    otp_app: :lv_testdrive,
    adapter: Ecto.Adapters.Postgres
end
