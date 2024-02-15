import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phelm, PhelmWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9pD/mhS4zus6z+phHR9B3xZ3nKcCvWP8wBxsD+h8ItLDLpp6v4/Rfzn2g4YCg3Yn",
  server: false

# In test we don't send emails.
config :phelm, Phelm.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
