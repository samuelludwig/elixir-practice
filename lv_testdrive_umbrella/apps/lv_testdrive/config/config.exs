# Since configuration is shared in umbrella projects, this file
# should only configure the :lv_testdrive application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :lv_testdrive,
  ecto_repos: [LvTestdrive.Repo]

import_config "#{Mix.env()}.exs"
