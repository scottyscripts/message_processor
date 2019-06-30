defmodule MessageProcessorWeb.Router do
  use MessageProcessorWeb, :router

  get "/receive-message",
      MessageProcessorWeb.MessageController,
      :schedule_message_for_processing
end
