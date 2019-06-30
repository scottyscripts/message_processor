defmodule MessageProcessor.ProcessingQueue do
  use GenServer
  require Logger

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting #{__MODULE__}")

    {:ok, state}
  end
end
