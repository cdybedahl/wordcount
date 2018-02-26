defmodule Wordcount.Printer do
  use GenServer

  @me __MODULE__

  ### API

  def start_link(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def print() do
    GenServer.call(@me, :print)
  end

  ### Callbacks

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_call(:print, _from, state) do
    Wordcount.Counter.get_table()
    |> format_table()
    |> IO.puts()

    {:reply, :ok, state}
  end

  ### Helpers

  def format_table(table) do
    top_10 =
      table
      |> Enum.sort(fn {_, m}, {_, n} -> n < m end)
      |> Enum.take(10)

    max_word_length =
      top_10
      |> Enum.map(fn {word, _} -> String.length(word) end)
      |> Enum.max()

    top_10
    |> Enum.map(fn {word, count} ->
      "#{String.pad_leading(word, max_word_length)} | #{count}"
    end)
    |> Enum.join("\n")
  end
end
