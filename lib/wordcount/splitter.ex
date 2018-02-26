defmodule Wordcount.Splitter do
  use GenServer

  @me __MODULE__

  ### API

  def start_link(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def add(data) do
    GenServer.cast(@me, {:add, data})
  end

  def process() do
    GenServer.cast(@me, :process)
  end

  ### Callbacks

  def init(:no_args) do
    {:ok, ""}
  end

  def handle_cast({:add, data}, buffer) do
    process()
    {:noreply, buffer <> data <> "\n"}
  end

  def handle_cast(:process, buffer) do
    String.split(buffer)
    |> Enum.each(&Wordcount.Counter.count/1)

    Wordcount.Reader.file_done()
    {:noreply, ""}
  end
end
