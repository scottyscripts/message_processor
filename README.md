# MessageProcessor

Message processing application built with Elixir, Phoenix, and Redis

## Run It

  1. Clone this repository locally and `cd` into new directory
  2. Install dependencies `mix deps.get`
  3. (Optional) Uncomment the following in `config/config.exs` to reduce noise in terminal where server is running
    ```
    # config :logger, level: :error
    ```
  4. Verify redis is running locally at `127.0.0.1:6379`
  5. Start server `mix phx.server`
  6. The application will run at `localhost:4000`

## How It Works
Make `GET` request to `/receive-message`

The endpoint accepts the following query string parameters
- `message` (required)
- `queue` (optional) default queue name can be edited in `config/config.exs`
  ```elixir
  config :message_processor,
    default_queue_name: "default"
  ```

After making a `GET` request to `/receive-message?message=yourmessage[&queue=somequeue]`

You should immediately receive a status code of `200`.

A GenServer `MessageProcessor.ProcessingQueue` will process the message based on the order it was received.

The GenServer will
  1. persist your `message` in a Redis list named whatever you specified as the `queue` (or the default queue name if you didn't specify a `queue` param)
  2. Add a reference to the `queue` of your message to a List representing a `ProcessingQueue` (this list is kept in the state of the GenServer)
  3. Every second, GenServer will look at `ProcessingQueue`'s queue kept in state, take the first item added (which is a reference to the Redis list/queue), get the first message that was added to that Redis list/queue, and process that message (print it in the server window)

## Try It Out

*Make sure your server is running (`mix phx.server`)*

### One Request at a Time

Try making a single `GET` request to the `/receive-message` endpoint

```bash
# --include flag will include HTTP headers of response
curl --include "http://localhost:4000/receive-message?message=message1&queue=queue1"
```

You should see `message1` print in the terminal window where the server was started.

### Many Requests at a Time

Try making many `GET` request to the `/receive-message` endpoint.

```bash
curl --include "http://localhost:4000/receive-message?message=message1&queue=queue1"
curl --include "http://localhost:4000/receive-message?message=message2&queue=queue2"
curl --include "http://localhost:4000/receive-message?message=message3&queue=queue3"
curl --include "http://localhost:4000/receive-message?message=message4&queue=queue4"
curl --include "http://localhost:4000/receive-message?message=message5&queue=queue5"
curl --include "http://localhost:4000/receive-message?message=message6&queue=queue6"
curl --include "http://localhost:4000/receive-message?message=message7&queue=queue7"
curl --include "http://localhost:4000/receive-message?message=message8&queue=queue7"
```

You should see the values of all `message` params print in the terminal window in the order they were received.

Each `message` will print one second apart.

## Plans To Scale

This is not a production application and is not expected to scale.

If I were implementing this in a production environment, I would look into using Amazon SQS in combination with [BroadwaySQS](https://github.com/plataformatec/broadway_sqs)

I would also ensure that all connections are secure and using SSL.
