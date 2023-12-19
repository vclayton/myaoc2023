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
		# [start] = find_start(grid)
		# dirs = find_dir(grid, start)
		%{size: tuple_size(grid), grid: grid}
	end

	def getxy(_grid, x, y) when x < 0 or y < 0, do: nil
	def getxy(grid, x, y) when x >= tuple_size(grid) or y >= tuple_size(grid), do: nil
	def getxy(grid, x, y), do: elem(elem(grid, y), x)
	# def setxy(grid, x, y, v), do: put_elem(grid, y, put_elem(elem(grid), y), x, v))

	# Returns the given column as a list
	def getcol(grid, x) do
		Enum.map(0..tuple_size(grid)-1, fn y -> getxy(grid, x, y) end)
	end

	def sum_col(col) do
		IO.inspect(col)
		Enum.reverse(col)
		|> Enum.with_index
		|> Enum.map(fn {item, weight} -> (weight + 1) * if?(item == "O", 1, 0) end)
		|> Enum.sum
	end

	def if?(test, t, _f) when test, do: t
	def if?(test, _t, f) when not test, do: f

	def add_weights(grid) do
		Enum.reduce(Tuple.to_list(grid), {0, tuple_size(grid)}, fn row, {total, val} ->
			weight = length(Enum.filter(Tuple.to_list(row), fn item -> item == "O" end))
			{total + weight * val, val - 1}
			|> IO.inspect
		end)
	end

	def tilt_grid(grid) do
		Enum.map(0..tuple_size(grid)-1, fn x -> getcol(grid, x) end)
		|> Enum.map(&tilt_col(&1))
	end

	def tilt_col(col) do
		Enum.reduce(1..length(col), col, fn _n, c -> do_tilt_col(c) end)
	end
	def do_tilt_col([]), do: []
	def do_tilt_col([".", "O" | more]), do: do_tilt_col(["O", "." | more])
	def do_tilt_col([x | more]), do: [x | do_tilt_col(more)]


	def part1(%{grid: grid}) do
		tilted = tilt_grid(grid)
		# |> IO.inspect
		|> Enum.map(&sum_col(&1))
		|> IO.inspect
		|> Enum.sum
		# add_weights(tilted)
	end

	def part2(inputs) do
		inputs
	end

end

Aoc.run("data/sample.14")
Aoc.run("data/input.14")
