defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# Returns [{card_id, winning, have}]
	def parse(input) do
		input
		|> String.trim
		|> String.split("\n")
		|> Enum.map(fn row ->
			String.split(row, ~r/[:|]/)
			# |> IO.inspect
			|> case do [card, wins, haves] ->
				{
					String.replace(card, ~r/^Card */, "") |> String.to_integer,
					String.trim(wins) |> String.split(~r/\s+/) |> Enum.map(&String.to_integer(&1)),
					String.trim(haves) |> String.split(~r/\s+/) |> Enum.map(&String.to_integer(&1))
				}
			end
		end)
	end

	def part1(input) do
		input
		|> Enum.map(fn {card, wins, haves} ->
			winners = haves |> Enum.filter(&Enum.member?(wins, &1))
			|> IO.inspect
			points = case length(winners) do
				0 -> 0
				n -> 2 ** (n-1)
			end
			{card, points}
		end)
		|> Enum.map(fn {_, points} -> points end)
		|> Enum.sum
	end

	def part2(input) do
		bonuses = List.duplicate(0, length(input))
		IO.inspect(bonuses)
		input
		|> Enum.map(fn {card, wins, haves} ->
			winners = haves |> Enum.filter(&Enum.member?(wins, &1))
			{card, {length(winners), 1}}
		end)
		|> IO.inspect
		|> Enum.reduce({0, bonuses}, &card_count/2)


		## Leftovers from failed approaches...
		# |> Enum.map(
		# |> Enum.reduce(%{}, fn {card, {wins, copies}}, cards ->
		# 	# new_copies = Enum.map(copies, fn c -> c - 1 end) |> Enum.filter(fn c -> c > 0 end)
		# 	Range.new(card+1, card+wins, 1)
		# 	|> IO.inspect
		# 	|> Enum.reduce(cards, fn copy_num ->
		# 		Map.update(cards, copy_num, 1, fn current_value -> current_value + 1 end)
		# 	end)
		# 	|> IO.inspect
		# 	# {total + 1 + length(new_copies), [wins|new_copies]}
		# 	# total + copies
		# end)
		# |> Enum.sum
	end

	def card_count({card, {wins, _copies}}, {total, [bonus|more_bonus]}) do
		new_bonus = for {b, index} <- Enum.with_index(more_bonus), do: b + (if index < wins do 1+bonus else 0 end)
		IO.inspect({card, new_bonus})
		{total + 1 + bonus, new_bonus}
	end

end

Aoc.run("data/sample.4")
Aoc.run("data/input.4")

