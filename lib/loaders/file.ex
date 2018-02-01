defmodule Weave.Loaders.File do
  @moduledoc """
  This loader will attempt to consume files located within a configured directory.
  The directory must be cofigured like one of the following:

  ```elixir
  config :weave, file_directory: "/some/path"
  ```

  ```elixir
  config :weave, file_directories: [
      "/some/path",
      "/some/other/path"
  ]
  ```

  With the above configuration, any files in the mentioned directories will be
  sent to the handler.

  Please note, the filenames will be "sanitized" before being sent to the handler.

  This means "/some/path/my_DB_password" will become "my_db_password"
  """

  use Weave.Loader
  require Logger

  @spec load_configuration(atom()) :: list()
  @spec get_configured_directories() :: list() | binary() | :weave_no_directory
  @spec load_configuration(binary(), binary(), atom()) :: :ok
  @spec load_configuration_from_directory(binary(), atom(), list()) :: :ok

  def load_configuration(handler) do
    with file_directories when file_directories !== [:weave_no_directory]
      <- get_configured_directories()
    do
      accepted_filenames = Application.get_env(:weave, :only)
      configured_keys = Enum.map(file_directories, fn(directory) ->
        load_configuration_from_directory(directory, handler, accepted_filenames)
      end)

      configured_keys
    else
      [:weave_no_directory] ->
        Logger.warn fn -> "Tried to load configuration, but {:weave, :file_directory or :file_directories} hasn't been configured" end
        []
    end
  end

  defp get_configured_directories do
    Application.get_env(:weave, :file_directories, [
      Application.get_env(:weave, :file_directory, :weave_no_directory)
    ])
  end

  defp load_configuration_from_directory(directory, handler, accepted_filenames) do
    Logger.info fn -> "Loading configuration from directory '#{directory}' ..." end

    directory
    |> String.trim_trailing("/")
    |> File.ls!()
    |> Enum.filter(fn(file) ->
      !File.dir?("#{directory}/#{file}")
    end)
    |> filter_filenames(accepted_filenames)
    |> Enum.map(fn(file) ->
      load_configuration(directory, file, handler)
      sanitize(file)
    end)
  end

  defp filter_filenames(files, nil), do: files
  defp filter_filenames(files, accepted_filenames) do
    # Allow variables names to be passed as string or atoms by converting everything to strings here
    only = Enum.map(accepted_filenames, &to_string/1)
    Enum.filter(files, fn file ->
      file in only
    end)
  end

  defp load_configuration(file_directory, file_name, handler) do
    configuration = "#{file_directory}/#{file_name}"
    |> File.read!()
    |> String.trim()

    apply_configuration(file_name, configuration, handler)
  end
end
