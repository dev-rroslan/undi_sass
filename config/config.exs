# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :undi, :env, Mix.env()

config :undi,
  ecto_repos: [Undi.Repo],
  generators: [binary_id: true]

config :undi, Undi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :undi,
  require_user_confirmation: true,
  app_name: "Undi",
  page_url: "undi.online",
  company_name: "Undi Enterprise",
  company_address: "499 BP 2/2, Banggol Permai",
  company_zip: "24000",
  company_city: "Chukai",
  company_state: "Terengganu",
  company_country: "Malaysia",
  contact_name: "Roslan Ramli",
  contact_phone: "+601125771566",
  contact_email: "roslanr@gmail.com",
  from_email: "roslan@undi.online"

# Configures the endpoint
config :undi, UndiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: UndiWeb.ErrorHTML, json: UndiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Undi.PubSub,
  live_view: [signing_salt: "uFdrYJ+H"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :undi, Undi.Mailer,
    adapter: Swoosh.Adapters.Sendgrid,
    api_key: System.get_env("SENDGRID_API_KEY")
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  config :swoosh, :api_client, Swoosh.ApiClient.Finch

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

  config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=../priv/static/assets/app.css.tailwind
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :dart_sass,
  version: "1.54.5",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :undi, Undi.Admins.Guardian,
  issuer: "undi",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "fG5Yl61b37W+aG/RLDY5GdWhMveGi0wySTmAMy69muI4KLXSEOZ0Y3s0GrBqyyBV"

config :undi, Oban,
  repo: Undi.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
       # {"0 2 * * *", Undi.Workers.DailyDigestWorker},
       # {"@reboot", Undi.Workers.StripeSyncWorker}
     ]}
  ]

config :saas_kit,
  admin: true,
  api_key: System.get_env("SAAS_KIT_API_KEY")
config :flop, repo: Undi.Repo
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
