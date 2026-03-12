# Example 3: Supervision and Fault Tolerance
# This program demonstrates Elixir's "Let It Crash" philosophy and
# self-healing systems using a basic Supervisor.

defmodule Worker do
  @doc """
  The work function runs in a separate process and performs a task.
  It is intentionally designed to crash if it receives an invalid input.
  """
  def work(id) do
    receive do
      {:perform, :crash} ->
        IO.puts("Worker #{id} is crashing as requested...")
        exit(:crashed)

      {:perform, task} ->
        IO.puts("Worker #{id} is performing task: #{task}")
        work(id)

      :shutdown ->
        IO.puts("Worker #{id} is shutting down.")
        :ok
    end
  end
end

defmodule SupervisorMock do
  @doc """
  A simplified supervisor that monitors a worker process and restarts it
  if it crashes unexpectedly.
  """
  def monitor(worker_id) do
    Process.flag(:trap_exit, true)
    # Spawn a new worker process
    pid = spawn_link(fn -> Worker.work(worker_id) end)
    Process.register(pid, :"worker_#{worker_id}") # Register the PID to a name
    IO.puts("Supervisor started Worker #{worker_id} (PID: #{inspect(pid)})")

    # Monitor the worker process
    receive do
      {:EXIT, ^pid, :crashed} ->
        IO.puts("Supervisor detected Worker #{worker_id} crashed! Restarting...")
        monitor(worker_id) # Restart the worker

      {:EXIT, ^pid, :normal} ->
        IO.puts("Supervisor: Worker #{worker_id} finished normally.")
        :ok
    end
  end
end

# Enable trapping exits so the main process doesn't crash when its children do
Process.flag(:trap_exit, true)

# 1. Start the supervisor in a separate process
IO.puts("--- Supervision and Fault Tolerance Demo ---")
_sup_pid = spawn(fn -> SupervisorMock.monitor(1) end)

# Give the supervisor time to start the worker
:timer.sleep(100)

# 2. Send a normal task to the worker
# We use the registered name to send the message
send(:worker_1, {:perform, "Analyzing data..."})

# 3. Send a message that causes the worker to crash
# The supervisor will catch this and restart the worker.
:timer.sleep(500)
send(:worker_1, {:perform, :crash})

# 4. Wait for the supervisor to restart the worker and send another task
:timer.sleep(500)
send(:worker_1, {:perform, "Generating report after restart..."})

# 5. Shut down everything
:timer.sleep(500)
send(:worker_1, :shutdown)

IO.puts("\n--- Self-Healing Demonstration Complete ---")
IO.puts("Note: This is how Elixir systems achieve 99.999% uptime.")
