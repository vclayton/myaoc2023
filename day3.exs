defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# Returns {numbers, symbols}
	def parse(input) do
		input
		|> String.trim
		|> String.split("\n")
		|> Enum.with_index(fn row, y ->
			Regex.scan(~r/([0-9]+|[.]+|[^.0-9]+)/, row, capture: :all_but_first)
			|> Enum.reduce({y, 0, [], []}, fn [token], {_, x, nums, symbols} ->
				next_x = x+String.length(token)
				case String.first(token) do
					"." -> {y, next_x, nums, symbols}
					d when d >= "0" and d <= "9" -> {y, next_x, [{x, x+String.length(token), y, token}|nums], symbols}
					_ -> {y, next_x, nums, [{x, y, token}|symbols]}
				end
			end)
		end)
		|> Enum.reduce({[], []}, fn {_y, _x, nums, symbols}, {acc_nums, acc_symbols} -> {[nums|acc_nums], [symbols|acc_symbols]} end)
		|> case do {nums, symbols} ->
			{Enum.concat(nums), Enum.concat(symbols)}
		end
		# |> IO.inspect
	end

	def part1(input) do
		{nums, symbols} = input
		# IO.inspect(symbols, limit: :infinity)
		parts = Enum.filter(nums, fn num ->
			Enum.any?(symbols, fn symbol -> is_adjacent?(symbol, num) end)
		end)

		parts
		|> Enum.map(fn {_x1, _x2, _y, val} -> String.to_integer(val) end)
		# |> IO.inspect(limit: :infinity)
		|> Enum.sum
	end

	# (symbol, number)
	def is_adjacent?({sym_x, sym_y, _}, {x1, x2, y, _}) do
		sym_x >= x1 - 1 and sym_x < x2 + 1 and sym_y >= y - 1 and sym_y <= y + 1
	end

	# Find the stars, match them up with adjacent numbers, filter to the ones with exactly two numbers
	def part2(input) do
		{nums, symbols} = input
		Enum.filter(symbols, fn {_x, _y, sym} -> sym == "*" end)
		|> IO.inspect
		|> Enum.map(fn {x, y, value} ->
			parts = Enum.filter(nums, fn num -> is_adjacent?({x, y, value}, num) end)
			{x, y, value, parts}
		end)
		|> IO.inspect(limit: :infinity)
		|> Enum.filter(fn {_x, _y, _sym, parts} -> length(parts) == 2 end)
		|> Enum.map(fn {x, y, _sym, [p1, p2]} ->
			{_,_,_,n1} = p1
			{_,_,_,n2} = p2
			String.to_integer(n1) * String.to_integer(n2)
		end)
		|> Enum.sum
	end
end

# Aoc.run("data/sample.3") # 4361
Aoc.run("data/input.3") # Part1: 494742 is too low, 538120 is too high, just right is 532331

