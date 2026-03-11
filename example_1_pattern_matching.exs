# Example 1: Pattern Matching and Recursion
# This program demonstrates Elixir's functional approach to problem-solving.
# Instead of loops, we use recursion and pattern matching in function heads.

defmodule Geometry do
  @doc """
  Calculates the area of various shapes using pattern matching on tuples.
  This illustrates how Elixir handles different data structures elegantly.
  """
  def area({:circle, radius}) do
    :math.pi() * radius * radius
  end

  def area({:rectangle, width, height}) do
    width * height
  end

  def area({:square, side}) do
    side * side
  end

  @doc """
  Calculates the factorial of a number using recursion and multiple function clauses.
  The first clause (the base case) is matched when n is 0.
  """
  def factorial(0), do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)
end

# Testing the Geometry module
IO.puts("--- Pattern Matching Examples ---")
IO.puts("Area of a circle (r=5): #{Geometry.area({:circle, 5})}")
IO.puts("Area of a rectangle (10x20): #{Geometry.area({:rectangle, 10, 20})}")
IO.puts("Area of a square (side=4): #{Geometry.area({:square, 4})}")

IO.puts("\n--- Recursion Example ---")
IO.puts("Factorial of 5: #{Geometry.factorial(5)}")
IO.puts("Factorial of 10: #{Geometry.factorial(10)}")
