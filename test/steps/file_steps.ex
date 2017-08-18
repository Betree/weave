defmodule Test.Feature.Steps.File do
  use Cabbage.Feature

  defgiven ~r/^I have configured Weave's file loader to load from a single directory, "(?<file_directory>[^"]+)"$/, %{file_directory: file_directory}, state do
    Application.put_env(:weave, :file_directory, file_directory)

    {:ok, Map.merge(state, %{file_directory: file_directory})}
  end

  defgiven ~r/^I have configured weave to load configuration from$/, %{table: directories}, state do
    secret_directories = Enum.map(directories, fn(map) ->
      map.directory
    end)

    Application.put_env(:weave, :file_directories, secret_directories)

    {:ok, Map.merge(state, %{file_directories: secret_directories})}
  end

  defgiven ~r/^the directory exists$/, _vars, state = %{file_directory: file_directory} do
    File.mkdir_p!(file_directory)

    {:ok, state}
  end

  defgiven ~r/^the directories exist$/, _vars, state = %{file_directories: file_directories} do
    Enum.each(file_directories, fn(directory) ->
      File.mkdir_p!(directory)
    end)

    {:ok, state}
  end

  defgiven ~r/^the following files exist there$/, %{table: files}, state = %{file_directory: file_directory} do
    Enum.each(files, fn(%{file_name: file_name, contents: contents}) ->
      File.write!("#{file_directory}/#{file_name}", contents)
    end)

    {:ok, Map.merge(state, %{expected_configuration: files})}
  end

  defgiven ~r/^the following files exist in the directories$/, %{table: files}, state do
    Enum.each(files, fn(%{directory: directory, file_name: file_name, contents: contents}) ->
      File.write!("#{directory}/#{file_name}", contents)
    end)

    {:ok, Map.merge(state, %{expected_configuration: files})}
  end

  defgiven ~r/^the following directories exist there$/, %{table: directories}, state = %{file_directory: file_directory} do
    Enum.each(directories, fn(%{directory_name: directory_name}) ->
      File.mkdir("#{file_directory}/#{directory_name}")
    end)

    {:ok, state}
  end

  defwhen ~r/^I run Weave's File loader$/, _vars, state do
    Weave.Loaders.File.load_configuration()

    {:ok, state}
  end

  defthen ~r/^my application should be configured$/, _vars, state = %{expected_configuration: expected_configuration} do
    Enum.each(
      Map.get(state, :file_directories, [Map.get(state, :file_directory)]),
      fn(directory) ->
        File.rm_rf(directory)
      end
    )

    Enum.each(expected_configuration, fn(%{file_name: key, contents: value}) ->
      assert Application.get_env(:weave, String.to_atom(key)) == value
    end)

    {:ok, %{}}
  end
end
