defmodule Test.Feature.MultipleLoaders do
  use Cabbage.Feature, file: "multiple_loaders.feature"

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.Environment
  import_steps Test.Feature.Steps.File

  defthen ~r/^my application should be configured by both loaders$/, _vars, _state do
    assert Application.get_env(:example_app, :database_host) == "my-database-host.com"
    assert Application.get_env(:example_app, :cookie_secret, "") == "I am super Secur3"
  end
end
