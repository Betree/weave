defmodule Weave.Loaders.Vault do
  @moduledoc """
  """
  use Weave.Loader
  require Logger

  @spec load_configuration(atom()) :: list()
  @spec get_vault_locations() :: list() | binary() | :weave_no_vault_locations
  @spec load_configuration_from_location(binary(), binary(), atom()) :: :ok

  @vault_adapter Vaultex.Client

  def load_configuration(handler) do
    adapter = Application.get_env(:weave, :vault_adapter, @vault_adapter)

    with vault_locations when vault_locations !== [:weave_no_vault_locations]
      <- get_vault_locations()
    do
      configured_keys = Enum.map(vault_locations, fn(location) ->
        load_configuration_from_location(adapter, location, handler)
      end)

      configured_keys
    else
      [:weave_no_vault_locations] ->
        Logger.warn fn -> "Tried to load configuration, but {:weave, :vault_locations} hasn't been configured" end
        []
    end
  end

  defp get_vault_locations do
    Application.get_env(:weave, :vault_locations, :weave_no_vault_locations)
  end

  defp load_configuration_from_location(adapter, location, handler) do
    Logger.info fn -> "Loading configuration from Vault location '#{location}' ..." end

    {:ok, configuration} = adapter.read(location)

    Enum.map(configuration, fn {key, value} ->
      apply_configuration(key, value, handler)
    end)
  end
end
