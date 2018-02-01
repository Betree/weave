defmodule Test.Feature.Steps.Shared do
  use Cabbage.Feature

  defand ~r/^I have configured Weave to use multiple loaders$/, _vars, _state do
    Application.put_env(:weave, :loaders, [
      Weave.Loaders.File,
      Weave.Loaders.Environment
    ])

    {:ok, %{}}
  end

  defand ~r/^I have configured the following variables in variables filter$/, %{table: variables}, state do
    variables_names = Enum.map(variables, &(Map.get(&1, :key)))
    Application.put_env(:weave, :only, variables_names)
    {:ok, Map.merge(state, %{only: variables_names})}
  end

  defand ~r/^I have not configured the variables filter with keyword "(?<keyword_only>[^"]+)"$/, _vars, state do
    {:ok, state}
  end

  defgiven ~r/^I have created my own Weave module$/, _vars, state do
    # Reset weave configuration
    for {key, _} <-  Application.get_all_env(:weave), do: Application.delete_env(:weave, key)
    # Reset example app configuration
    for {key, _} <-  Application.get_all_env(:example_app), do: Application.delete_env(:example_app, key)
    {:ok, state}
  end

  defwhen ~r(^I run my Weave module's configure/0$), _vars, state do
    MyApp.Weave.configure()

    {:ok, state}
  end

  defthen ~r/^it shouldn't fail and return an empty list$/, _vars, state do
    {:ok, state}
  end
end
