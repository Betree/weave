defmodule Test.Feature.Steps.Shared do
  use Cabbage.Feature

  defand ~r/^I have configured Weave to use multiple loaders$/, _vars, _state do
    Application.put_env(:weave, :loaders, [
      Weave.Loaders.File,
      Weave.Loaders.Environment
    ])

    {:ok, %{}}
  end

  defgiven ~r/^I have created my own Weave module$/, _vars, state do
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
