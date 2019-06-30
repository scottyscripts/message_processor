defmodule MessageProcessor.ProcessingQueue do
  use GenServer
  require Logger

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting #{__MODULE__}")

    {:ok, conn} = Redix.start_link

    {:ok, %{conn: conn, queue: []}}
  end

  def enqueue(message, message_queue) do
    GenServer.cast(
      __MODULE__,
      {:enqueue, %{message: message, message_queue: message_queue}}
    )
  end

  def handle_cast(
    {:enqueue, %{message: message, message_queue: message_queue}},
    %{conn: conn, queue: queue} = state
  ) do
    case Redix.command(conn, ["RPUSH", message_queue, message]) do
      {:ok, response} ->
        Logger.info("message: '#{message}' from queue: '#{message_queue}' persisted to Redis and queued for processing")
        {:noreply, %{conn: conn, queue: queue ++ [message_queue]}}
      {:error, _reason} ->
        Logger.error("message: '#{message}' from queue: '#{message_queue}' failed to persist to Redis and will not be queued for processing")
        {:noreply, %{conn: conn, queue: queue}}
    end
  end
end
