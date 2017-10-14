defmodule Test.Feature.Steps.Vault do
  use Cabbage.Feature

  defand ~r/^I have configured Weave's Vault loader to load from a single location, "(?<location>[^"]+)"$/, %{location: location}, state do
    Application.put_env(:weave, :vault_locations, [location])
    Application.put_env(:weave, :vault_adapter, Weave.TestVaultAdapter)

    {:ok, %{}}
  end

  defand ~r/^the locations exists$/, _vars, state do
    Application.get_env(:weave, :vault_locations)
    |> Enum.each(fn(location) ->
      Weave.TestVaultAdapter.store(location)
    end)

    {:ok, state}
  end

  defand ~r/^the following secrets exist there$/, %{table: secrets}, state do
    secrets = Enum.map(secrets, fn(%{location: location, secret: key, contents: value}) ->
      Weave.TestVaultAdapter.store(location, key, value)

      %{location: location, key: key, value: value}
    end)

    {:ok, Map.put(state, :secrets, secrets)}
  end

  defwhen ~r/^I run Weave's Vault loader$/, _vars, state do
    Weave.Loaders.Vault.load_configuration(MyApp.Weave)

    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, state do
    state
    |> Map.get(:secrets)
    |> Enum.each(fn(%{location: location, key: key, value: value}) ->
      assert Application.get_env(:example_app, :vault_secret_1, "Vault is awesome")
    end)

    {:ok, %{}}
  end
end
