# Since configuration is shared in umbrella projects, this file
# should only configure the :lv_testdrive_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :lv_testdrive_web,
  ecto_repos: [LvTestdrive.Repo],
  generators: [context_app: :lv_testdrive]

# Configures the endpoint
config :lv_testdrive_web, LvTestdriveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aok6Dpi9kOxP+CFmNH2TtIATujfai2wMDYbjng/AWJtShVD0qes43D4o0pk7r+Ft",
  render_errors: [view: LvTestdriveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LvTestdriveWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
