# Example 2: The Actor Model and Message Passing
# This program demonstrates Elixir's core concurrency primitives:
# spawn, send, and receive.

defmodule Messenger do
  @doc """
  The listen function runs in its own lightweight process.
  It waits for messages in its mailbox and processes them using pattern matching.
  """
  def listen do
    receive do
      {:greet, name} ->
        IO.puts("Hello, #{name}! This message was processed in a background process.")
        listen() # Recurse to keep the process alive for more messages

      {:add, a, b, sender_pid} ->
        IO.puts("Calculating #{a} + #{b}...")
        send(sender_pid, {:result, a + b})
        listen()

      :shutdown ->
        IO.puts("Process is shutting down gracefully.")
        :ok

      _ ->
        IO.puts("Received an unknown message.")
        listen()
    end
  end
end

# 1. Spawn a new process running the Messenger.listen function
# This returns a Process ID (PID).
pid = spawn(fn -> Messenger.listen() end)

# 2. Send an asynchronous message to the process
# The current process continues immediately (non-blocking).
send(pid, {:greet, "Manus User"})

# 3. Perform a calculation by sending a message and waiting for a response
# This illustrates the standard "request-response" pattern in Elixir.
send(pid, {:add, 15, 27, self()})

# The current process blocks until it receives the result from the Messenger process
receive do
  {:result, sum} ->
    IO.puts("Received the result from the background process: #{sum}")
after
  2000 ->
    IO.puts("Timed out waiting for a response.")
end

# 4. Shut down the background process
send(pid, :shutdown)

IO.puts("\n--- Concurrency Demonstration Complete ---")
IO.puts("Note: Each BEAM process is isolated and has its own memory heap.")
