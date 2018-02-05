defmodule Test.Feature.Steps.Environment do
  use Cabbage.Feature

  defand ~r/^I have configured Weave's Environment loader to load environment variables with prefix "(?<environment_prefix>[^"]+)"$/, %{environment_prefix: environment_prefix}, state do
    Application.put_env(:weave, :environment_prefix, environment_prefix)
    {:ok, Map.merge(state, %{environment_prefix: environment_prefix})}
  end

  defand ~r/^I have not configured the environment prefix$/, _vars, state do
    {:ok, state}
  end

  defand ~r/^the following environment variables exist$/, %{table: variables}, state do
    environment_prefix = Map.get(state, :environment_prefix) || ""
    Enum.each(variables, fn(%{key: key, value: value}) ->
      System.put_env("#{environment_prefix}#{key}", value)
    end)
    expected = Enum.map variables, fn %{key: key, value: value} ->
      %{key: String.downcase(key), value: value}
    end
    {:ok, Map.merge(state, %{expected_configuration: expected})}
  end

  defwhen ~r/^I run Weave's Environment loader$/, _vars, state do
    Weave.Loaders.Environment.load_configuration(MyApp.Weave)
    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, state = %{expected_configuration: expected_configuration} do
    all_expected_keys = Enum.map(expected_configuration, &(Map.get(&1, :key)))
    only = Map.get(state, :only, all_expected_keys)
    Enum.each(expected_configuration, fn(%{key: key, value: value}) ->
      if key in only do
        assert Application.get_env(:example_app, String.to_atom(key)) == value
      else
        refute Application.get_env(:example_app, String.to_atom(key))
      end
    end)
    {:ok, %{}}
  end
end
