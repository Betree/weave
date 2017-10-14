defmodule Weave.TestVaultAdapter do
  @moduledoc false

  use GenServer

  @doc false
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  @doc false
  def store(location) do
    GenServer.call(Weave.TestVaultAdapter, {:store, location})
  end

  @doc false
  def store(location, key, value) do
    GenServer.call(Weave.TestVaultAdapter, {:store, location, key, value})
  end

  @doc false
  def read(location) do
    GenServer.call(Weave.TestVaultAdapter, {:read, location})
  end

  @doc false
  def handle_call({:store, location, key, value}, _from, state) do
    updated_location = state
    |> Map.get(location)
    |> Map.merge(Map.put_new(%{}, key, value))

    {:reply, :ok, Map.put(state, location, updated_location)}
  end

  @doc false
  def handle_call({:store, location}, _from, state) do
    {:reply, :ok, Map.put(state, location, %{})}
  end

  @doc false
  def handle_call({:read, location}, _from, state) do
    {:reply, {:ok, Map.get(state, location, %{})}, state}
  end
end
