defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	def parse(input) do
		input
		|> String.trim
		|> String.split("\n")
		|> Enum.map(fn i ->
			String.split(i, ~r/[:;]/)
			|> Enum.map(&String.trim(&1))
			|> parse_game
		end)
	end

	def parse_game(["Game " <> game_id | colors]) do
		{String.to_integer(game_id), Enum.reduce(colors, %{"red" => 0, "green" => 0, "blue" => 0}, &parse_colors/2)}
	end

	def parse_colors(current, totals) do
		Regex.scan(~r/([0-9]*) (red|green|blue)/, current, capture: :all_but_first)
		|> Enum.reduce(totals, fn [num, color], total ->
			Map.update!(total, color, &(max(&1, String.to_integer(num))))
#			%{total | color => max(Map.get(total, color), String.to_integer(num))} # Does the same as the Map.update! call above
		end)
		# |> IO.inspect
	end

	def part1(input), do: do_part1(input, 12, 13, 14)
	def do_part1(games, max_red, max_green, max_blue) do
		games
		|> IO.inspect
		|> Enum.filter(fn g -> game_possible(g, max_red, max_green, max_blue) end)
		|> IO.inspect
		|> Enum.map(fn {id, _} -> id end)
		|> Enum.sum
	end

	def game_possible({_id, %{"red" => r, "green" => g, "blue" => b}}, max_r, max_g, max_b) do
		r <= max_r and g <= max_g and b <= max_b
	end

	def part2(input) do
		Enum.map(input, fn {_id, %{"red" => r, "green" => g, "blue" => b}} -> r * g * b end)
		|> Enum.sum
	end
end

Aoc.run("data/sample.2") # Expected Part 1: 8. Part 2: 2286
Aoc.run("data/input.2") # 254 is too low :(

