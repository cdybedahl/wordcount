defmodule Wordcount.Reader do
  use GenServer

  @me __MODULE__

  ### API

  def start_link(_arg) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def read(filename) do
    GenServer.cast(@me, {:add_file, filename})
  end

  def file_done() do
    GenServer.cast(@me, :file_done)
  end

  ### Callbacks

  def init(:no_args) do
    {:ok, %{count: 0}}
  end

  def handle_cast({:add_file, filename}, state) do
    case File.read(filename) do
      {:ok, data} ->
        Wordcount.Splitter.add(data)
        {:noreply, update_in(state.count, fn n -> n + 1 end)}

      {:error, _whatever} ->
        {:noreply, state}
    end
  end

  def handle_cast(:file_done, state = %{count: 1}) do
    Wordcount.Printer.print()
    {:noreply, update_in(state.count, fn n -> n - 1 end)}
  end

  def handle_cast(:file_done, state = %{count: count}) when count > 1 do
    {:noreply, update_in(state.count, fn n -> n - 1 end)}
  end
end
