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
  require Logger

  @spec load_configuration(atom()) :: list()

  def load_configuration(handler) do
    env_prefix = Application.get_env(:weave, :environment_prefix)
    variables_filter = Application.get_env(:weave, :only)

    System.get_env()
    |> filter_env(env_prefix, variables_filter)
    |> Enum.map(fn {key, value} ->
      apply_configuration(key, value, handler)
      sanitize(key)
    end)
  end

  defp filter_env(_, nil, nil) do
    Logger.warn "Please provide an environment prefix or a variable filter (with :only) with environement loader"
    []
  end
  defp filter_env(environment_variables, environment_prefix, variables_filter) do
    environment_variables
    |> filter_env_prefix(environment_prefix)
    |> filter_env_only(variables_filter)
  end

  defp filter_env_prefix(variables, nil), do: variables
  defp filter_env_prefix(variables, environment_prefix) do
    variables
    |> Enum.filter(fn {key, _value} ->
      String.starts_with?(key, environment_prefix)
    end)
    |> Enum.map(fn {key, value} ->
      {String.trim_leading(key, environment_prefix), value}
    end)
  end

  defp filter_env_only(variables, nil), do: variables
  defp filter_env_only(variables, only) do
    # Allow variables names to be passed as string
    # or atoms by converting everything to strings here
    only = Enum.map(only, fn key -> String.downcase(to_string(key))  end)
    Enum.filter(variables, fn {key, _} ->
      String.downcase(key) in only
    end)
  end
end
