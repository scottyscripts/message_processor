defmodule MessageProcessorWeb.MessageControllerTest do
  use MessageProcessorWeb.ConnCase

  describe "GET /receive_message" do
    test "Returns a status code of 200 if only 'message' param sent",
          %{conn: conn}
    do
      response = conn
                 |> get("/receive-message", %{message: "some message"})

      assert response.status == 200
    end

    test "Returns a status code of 200 if 'message' and 'queue' param sent",
          %{conn: conn}
    do
      response = conn
                 |> get("/receive-message", %{message: "some message", queue: "queue1"})

      assert response.status == 200
    end

    test "Returns a status code of 500 if 'message' param not sent",
          %{conn: conn}
    do
      response = conn
                 |> get("/receive-message")

      assert response.status == 500
    end
  end
end
