defmodule MessageProcessor.ProcessingQueue do
  use GenServer
  require Logger

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    Logger.info("Starting #{__MODULE__}")
    {:ok, conn} = Redix.start_link
    process_next()

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
    %{conn: conn, queue: queue}
  ) do
    case Redix.command(conn, ["RPUSH", message_queue, message]) do
      {:ok, _response} ->
        Logger.info("message: '#{message}' from queue: '#{message_queue}' persisted to Redis and queued for processing")

        {:noreply, %{conn: conn, queue: queue ++ [message_queue]}}
      {:error, _reason} ->
        Logger.error("message: '#{message}' from queue: '#{message_queue}' failed to persist to Redis and will not be queued for processing")

        {:noreply, %{conn: conn, queue: queue}}
    end
  end

  def handle_info(:process, %{conn: conn, queue: queue}) do
    {message_queue, updated_queue} = List.pop_at(queue, 0)
    unless Enum.empty?(queue) do
      {:ok, message} = Redix.command(conn, ["LPOP", message_queue])

      process_message(message)
      Logger.info("Processed message: '#{message}' from queue: '#{message_queue}'")
    end
    process_next()

    {:noreply, %{conn: conn, queue: updated_queue}}
  end

  defp process_next() do
    Process.send_after(self(), :process, 1_000)
  end

  # this is the actual processing in this example
  #   in real world would error handle this processing step
  defp process_message(message) do
    IO.puts(message)
  end
end
