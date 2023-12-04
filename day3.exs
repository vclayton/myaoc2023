defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		# IO.inspect ["Part 2:", part2(parse(input))]
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
					d when d >= "0" and d <= "9" -> {y, next_x, [{x, y, token}|nums], symbols}
					_ -> {y, next_x, nums, [{x, y, token}|symbols]}
				end
			end)
		end)
		|> Enum.reduce({[], []}, fn {_y, _x, nums, symbols}, {acc_nums, acc_symbols} -> {[nums|acc_nums], [symbols|acc_symbols]} end)
		|> case do {nums, symbols} ->
			{Enum.concat(nums), Enum.concat(symbols)}
		end
		|> IO.inspect
	end

	def part1(input) do
		{nums, symbols} = input
		# IO.inspect(symbols, limit: :infinity)
		parts = Enum.filter(nums, fn {x1, y, value} ->
			x2 = x1 + String.length(value)
			Enum.any?(symbols, fn {sym_x, sym_y, _} ->
				sym_x >= x1 - 1 and sym_x < x2 + 1 and sym_y >= y - 1 and sym_y <= y + 1
			end)
		end)
		non_parts = nums -- parts
		# IO.inspect(parts, limit: :infinity)
		# IO.inspect(non_parts, limit: :infinity)

		parts
		|> Enum.map(fn {_x, _y, val} -> String.to_integer(val) end)
		# |> IO.inspect(limit: :infinity)
		|> Enum.sum
	end

	def part2(input) do
		{nums, symbols} = input
		Enum.map(input, fn {_id, %{"red" => r, "green" => g, "blue" => b}} -> r * g * b end)
		|> Enum.sum
	end
end

# Aoc.run("data/sample.3") # 4361
Aoc.run("data/input.3") # 494742 is too low, 538120 is too high

