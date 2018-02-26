defmodule Wordcount do
  def files(namelist) do
    Enum.each(namelist, fn name -> Wordcount.Reader.read(name) end)
  end
end
