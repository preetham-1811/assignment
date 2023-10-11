# Workers = production core count

workers 2
preload_app!

# Threads: 1 to 5 per worker

threads 1, 5

# Run on port 3000

port ENV.fetch("PORT") { 3000 }

# Run in development mode by default, or allow override by environment var

rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# Application location

app_dir = File.expand_path("../..", __FILE__)

# Specifies the `pidfile` that Puma will use.

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
state_path ENV.fetch("STATEFILE") {"tmp/sockets/puma.state" }

# Socket location

bind "unix://#{app_dir}/tmp/sockets/puma.sock"

# Allow puma to be restarted by `rails restart` command.

plugin :tmp_restart

# Control app

activate_control_app
