defmodule Test.Feature.RequiredConfig do
  use Cabbage.Feature, file: "required_config.feature"

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.Environment
  import_steps Test.Feature.Steps.File

  defand ~r/^I have configured Weave to use the Environment loader$/, _vars, _state do
    Application.put_env(:weave, :loaders, [Weave.Loaders.Environment])
  end

  defand ~r/^I have configured Weave to use the File loader$/, _vars, _state do
    Application.put_env(:weave, :loaders, [Weave.Loaders.File])
  end

  defthen ~r/^my application shouldn't raise an error$/, _vars, _state do
    :ok
  end

  defthen ~r/^my application should exit with an error when configuring$/, _vars, _state do
    assert_raise(RuntimeError, fn ->
      MyApp.Weave.configure()
    end)
  end
end
