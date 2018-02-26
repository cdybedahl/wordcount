defmodule Wordcount.Application do
  use Application

  def start(_type, _args) do
    children = [
      Wordcount.Reader,
      Wordcount.Splitter,
      Wordcount.Counter,
      Wordcount.Printer
    ]

    opts = [strategy: :one_for_one, name: Wordcount.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
