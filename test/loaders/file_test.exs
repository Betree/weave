defmodule Test.Feature.Loaders.File do
  use Cabbage.Feature, file: "loaders/file.feature", async: false

  import_steps Test.Feature.Steps.Shared
  import_steps Test.Feature.Steps.File

  setup do
    on_exit fn ->
      Application.delete_env(:weave, :file_directory)
      Application.delete_env(:weave, :file_directories)
    end

    {:ok, %{}}
  end
end
