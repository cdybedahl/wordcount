defmodule Wordcount.Splitter.Worker do
  use GenServer, restart: :transient

  @me __MODULE__

  ### API

  def start_link(data) do
    GenServer.start_link(@me, data, name: @me)
  end

  defp process() do
    GenServer.cast(@me, :process)
  end

  ### Callbacks

  def init(data) do
    process()
    {:ok, data}
  end

  def handle_cast(:process, buffer) do
    String.split(buffer)
    |> Enum.each(&Wordcount.Counter.count/1)

    Wordcount.Reader.file_done()
    {:stop, :normal, ""}
  end
end
