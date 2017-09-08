defmodule Weave do
  @moduledoc """
  Weave
  """

  defmacro __using__(_opts) do
    quote do
      import Weave

      @required   []
      @configured []

      @spec configure() :: :ok

      @before_compile Weave
    end
  end

  defmacro weave(name, [required: true, handler: handler]) do
    quote do
      @required [unquote(name)] ++ @required

      generate_handler(unquote(name), unquote(handler))
    end
  end

  defmacro weave(name, [required: false, handler: handler]) do
    quote do
      generate_handler(unquote(name), unquote(handler))
    end
  end

  defmacro weave(name, [handler: handler]) do
    quote do
      generate_handler(unquote(name), unquote(handler))
    end
  end

  defmacro generate_handler(name, handler = {:fn, _, _}) when is_tuple(handler) do
    quote do
      def handle_configuration(unquote(name), value) do
        unquote(handler).(value)
      end
    end
  end

  defmacro generate_handler(name, handler) when is_tuple(handler) do
    quote do
      def handle_configuration(unquote(name), value) do
        {app, key} = unquote(handler)
        {app, key, value}
      end
    end
  end

  defmacro generate_handler(name, handler) when is_list(handler) do
    quote do
      def handle_configuration(unquote(name), value) do
        Enum.map(unquote(handler), fn({app, key}) ->
          {app, key, value}
        end)
      end
    end
  end

  defmacro __before_compile__(_environment) do
    quote do
      def configure do
        :weave
        |> Application.get_env(:loaders)
        |> Enum.map(fn(loader) ->
          loader.load_configuration(__MODULE__)
        end)
        |> strict()

        :ok
      end

      def strict(configured_keys) do
        missing_keys = @required -- List.flatten(configured_keys)

        if Kernel.length(missing_keys) > 0 do
          raise "Not all required configuration met. Missing #{inspect missing_keys}"
        end
      end
    end
  end
end
