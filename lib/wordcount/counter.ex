defmodule Wordcount.Counter do
  use GenServer

  @me __MODULE__

  ### API

  def start_link(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def count(word) do
    GenServer.call(@me, {:count, word})
  end

  def get_table() do
    GenServer.call(@me, :get_table)
  end

  ### Callbacks

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_call({:count, word}, _from, state) do
    {:reply, :ok, update_in(state[word], fn n -> 1 + (n || 0) end)}
  end

  def handle_call(:get_table, _from, state) do
    {:reply, state, state}
  end
end
