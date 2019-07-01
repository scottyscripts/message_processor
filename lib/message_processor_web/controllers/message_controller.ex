defmodule MessageProcessorWeb.MessageController do
  use MessageProcessorWeb, :controller

  @default_queue_name Application.get_env(:message_processor, :default_queue_name)

  def schedule_message_for_processing(conn, %{"message" => message} = params) do
    queue = Map.get(params, "queue")
            |> determine_queue_name

    message
    |> MessageProcessor.ProcessingQueue.enqueue(queue)

    conn
    |> send_resp(200, "")
  end

  def schedule_message_for_processing(conn, _params) do
    conn
    |> put_status(500)
    |> json(%{error: "Specify the following params: 'message' (required), 'queue' (optional)'"})
  end

  defp determine_queue_name(nil), do: @default_queue_name
  defp determine_queue_name(""), do: @default_queue_name
  defp determine_queue_name(queue_name), do: queue_name
end
