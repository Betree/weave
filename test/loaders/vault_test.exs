defmodule Test.Feature.Loaders.Vault do
  use Cabbage.Feature, file: "loaders/vault.feature", async: false

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.Vault

  setup do
    on_exit fn ->
    end

    {:ok, %{}}
  end
end
