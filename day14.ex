defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# %{size, {start}, grid}
	def parse(input) do
		grid = String.trim(input)
		|> String.split("\n")
		|> Enum.map(fn row -> String.graphemes(row) |> List.to_tuple end)
		|> List.to_tuple
		# |> IO.inspect
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
		# IO.inspect(col)
		Enum.reverse(col)
		|> Enum.with_index
		|> Enum.map(fn {item, weight} -> (weight + 1) * if?(item == "O", 1, 0) end)
		|> Enum.sum
	end

	def if?(test, t, _f) when test, do: t
	def if?(test, _t, f) when not test, do: f

	def grid_tuple_to_list(grid) do
		Enum.map(0..tuple_size(grid)-1, fn x -> getcol(grid, x) end)
	end

	def tilt_grid(grid) do
		grid |> Enum.map(&tilt_col(&1))
	end

	def tilt_col(col) do
		Enum.reduce(1..length(col), col, fn _n, c -> do_tilt_col(c) end)
	end
	def do_tilt_col([]), do: []
	def do_tilt_col([".", "O" | more]), do: do_tilt_col(["O", "." | more])
	def do_tilt_col([x | more]), do: [x | do_tilt_col(more)]


	def part1(%{grid: grid}) do
		tilt_grid(grid_tuple_to_list(grid))
		# |> IO.inspect
		|> Enum.map(&sum_col(&1))
		|> IO.inspect
		|> Enum.sum
	end

	# Reorients the columns in the grid so that the data has been rotated 90 degrees widdershins.
	def rotate_grid(grid) do
		Enum.reverse(transpose(grid))
	end

	def transpose(grid) do
		Enum.zip(grid)
		|> Enum.map(&Tuple.to_list(&1))
	end

	def spin(grid) do
		tilt_grid(grid)
		|> rotate_grid
		|> tilt_grid
		|> rotate_grid
		|> tilt_grid
		|> rotate_grid
		|> tilt_grid
		|> rotate_grid
	end

	def grid_to_string(grid) do
		Enum.map(grid, fn r -> Enum.join(r, "") end)
		|> Enum.join("\n")
	end

	def display_grid(grid) do
		# Enum.map(transpose(grid), fn r -> Enum.join(r, " ") end)
		# |> Enum.join("\n")
		# |> IO.puts
		grid_to_string(transpose(grid))
		|> IO.puts
		IO.puts("===")
		grid
	end

	def part2(%{grid: grid}) do
		north = grid_tuple_to_list(grid)
		# north
		# |> spin
		# |> display_grid
		# |> spin
		# |> display_grid
		# |> spin
		# |> display_grid

		# # The naive way, to test the sample output
		# Enum.reduce(1..1000, north, fn n, g ->
		# 	str = grid_to_string(g)
		# 	hash = Base.encode16(:crypto.hash(:md5, str))
		# 	load = Enum.map(g, &sum_col(&1)) |> Enum.sum
		# 	IO.inspect({n, hash, load})
		# 	spin(g)
		# end)

		# Run until we detect a loop, given a cap of 1000 tries
		{repeat, history} = Enum.reduce_while(1..1000, {north, []}, fn n, {g, history} ->
			str = grid_to_string(g)
			hash = Base.encode16(:crypto.hash(:md5, str))
			load = Enum.map(g, &sum_col(&1)) |> Enum.sum
			round = {n, hash, load}
			if repeat = List.keyfind(history, hash, 1, false) do
				{:halt, {repeat, Enum.reverse([round | history])}}
			else
				{:cont, {spin(g), [round | history]}}
			end
		end)

		cycles = 1000000000
		{offset, _hash, _weights} = repeat
		cycle_length = length(history) - offset
		IO.inspect({cycle_length, offset})
		target = rem((cycles - offset), cycle_length) + offset
		Enum.at(history, target)
	end

end

# Aoc.run("data/sample.14")
Aoc.run("data/input.14")
