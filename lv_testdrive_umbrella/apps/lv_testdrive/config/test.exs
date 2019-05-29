# Since configuration is shared in umbrella projects, this file
# should only configure the :lv_testdrive application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :lv_testdrive, LvTestdrive.Repo,
  username: "postgres",
  password: "postgres",
  database: "lv_testdrive_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
