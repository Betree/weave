defmodule MyApp.Weave do
  @moduledoc """
  Example Weave Module
  """
  use Weave

  weave "database_host",      required: true,
    handler: {:example_app, :database_host}

  weave "database_password",  handler: {:example_app, :database_password}
  weave "database_port",      handler: {:example_app, :database_port}
  weave "cookie_secret",      handler: {:example_app, :cookie_secret}

  weave "multi",              handler: [{:example_app, :one}, {:example_app, :two}]

  weave "log_level",          handler: fn(log_level) ->
    Logger.configure(level: String.to_atom(log_level))

    :ok
  end

  weave "vault_secret_1", handler: {:example_app, :vault_secret_1}
end
