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
		[start] = find_start(grid)
		dirs = find_dir(grid, start)
		%{size: tuple_size(grid), start: start, grid: grid}
	end

	def find_start(grid) do
		for x <- 0..tuple_size(grid)-1, y <- 0..tuple_size(grid)-1, getxy(grid, x, y) == "S", do: {x,y}
	end

	def connects?(grid, {x,y}, :right) do
		case getxy(grid, x+1, y) do
			"-" -> true
			"7" -> true
			"J" -> true
			_ -> false
		end
	end
	def find_dir(grid, {x,y}) do
		[:right] |> Enum.filter(fn dir -> connects?(grid, {x, y}, dir) end)
	end

	def getxy(grid, x, y) when x < 0 or y < 0, do: nil
	def getxy(grid, x, y) when x >= tuple_size(grid) or y >= tuple_size(grid), do: nil
	def getxy(grid, x, y), do: elem(elem(grid, y), x)
	def parse_loops(%{size: s, grid: g, start: start}) do
		for x <- 0..s-1, y <- 0..s-1, getxy(g, x, y) == "S", do: {x,y}
	end
	def follow_loop(start, {x,y}, grid, path) when start == {x,y}, do: path
	def follow_loop(start, {x,y}, grid, path) do
		next = case getxy(grid, x, y) do
			"-" -> :foo
		end
		[next | follow_loop(start, next, grid, path)]
	end

	def part1(inputs) do
		parse_loops(inputs)
	end

	def part2(inputs) do
		inputs
	end

end

Aoc.run("data/sample.10.0.0")
# Aoc.run("data/input.10")
