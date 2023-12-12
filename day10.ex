defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		# IO.inspect ["Part 2:", part2(parse(input))]
	end

	# %{size, {start}, grid}
	def parse(input) do
		grid = String.trim(input)
		|> String.split("\n")
		|> Enum.map(fn row -> String.graphemes(row) |> List.to_tuple end)
		|> List.to_tuple
		|> IO.inspect
		%{size: tuple_size(grid), grid: grid}
	end

	def parse_loops(inputs) do
		# for y <- inputs, x <-
	end

	def part1(inputs) do
		inputs
	end

	def part2(inputs) do
		inputs
	end

end

Aoc.run("data/sample.10.0.0")
# Aoc.run("data/input.10")
