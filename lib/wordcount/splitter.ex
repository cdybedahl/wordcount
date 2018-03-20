defmodule Wordcount.Splitter do
    use DynamicSupervisor

    @me __MODULE__

    ### API

    def start_link(_) do
        DynamicSupervisor.start_link(@me, :no_args, name: @me)
    end

    def add(data) do
        DynamicSupervisor.start_child(@me, Wordcount.Splitter.Worker.child_spec(data))
    end

    ### Callbacks

    def init(:no_args) do
        DynamicSupervisor.init(strategy: :one_for_one)
    end
end