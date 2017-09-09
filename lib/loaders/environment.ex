defmodule Weave.Loaders.Environment do
  @moduledoc """
  This loader will utilise the available environment variables to provide configuration. A prefix must be specified in the configuration:

  ```elixir
  config :weave, environment_prefix: "MY_APP_"
  ```

  With the above configuration, any environment variables that begin with `MY_APP_` will be sent to the handler. Please note, these will be "sanitized" before being sent to the handler.

  This means "MY_APP_NAME" will become "name"
  """
  use Weave.Loader

  @spec load_configuration(atom()) :: list()

  def load_configuration(handler) do
    with {:ok, environment_prefix}
        <- Application.fetch_env(:weave, :environment_prefix),
      environment_variables
        <- System.get_env()
    do
      configured_keys = environment_variables
      |> Enum.filter(fn({key, value}) ->
        String.starts_with?(key, environment_prefix)
      end)
      |> Enum.map(fn({key, value}) ->
        {String.trim_leading(key, environment_prefix), value}
      end)
      |> Enum.map(fn({key, value}) ->
        apply_configuration(key, value, handler)

        sanitize(key)
      end)
      configured_keys
    else
      _ ->
          Logger.warn fn -> "Tried to load configuration, but :weave hasn't been configured properly. Check :environment_prefix" end
          []
    end
  end
end
