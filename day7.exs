defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# [{time, dist}]
	def parse(input) do
		input
		|> String.trim
		|> String.split("\n")
		|> Enum.map(fn row ->
			[cards, bid] = String.split(row, " ")
			parse_hand(cards, String.to_integer(bid))
		end)
	end

	def parse_hand(cards, bid) do
		%{
			hand: cards,
			type: parse_type(cards),
			order: parse_order(cards),
			bid: bid,
			rank: 0,
		}
	end

	def parse_type_1(cards) do
		String.to_charlist(cards)
		|> Enum.frequencies
		|> Map.values
		|> Enum.sort
		|> Enum.reverse
		|> match_type
	end

	def parse_type(cards) do
		{jokers, freqs} = String.to_charlist(cards)
		|> Enum.frequencies
		|> IO.inspect
		|> Map.pop(?J, 0)

		IO.inspect(freqs)
		Map.values(freqs)
		|> Enum.sort
		|> Enum.reverse
		|> then(fn vals ->
			IO.inspect({cards, jokers, vals})
			match_type2(jokers, vals)
		end)
	end

	def match_type([5]), do: {:five, 7}
	def match_type([4,1]), do: {:four, 6}
	def match_type([3,2]), do: {:fullhouse, 5}
	def match_type([3,1,1]), do: {:three, 4}
	def match_type([2,2,1]), do: {:twopair, 3}
	def match_type([2,1,1,1]), do: {:onepair, 2}
	def match_type([1,1,1,1,1]), do: {:highcard, 1}

	# Given (NumberOfJokers, [numbers of each non-joker])
	def match_type2(5, _), do: {:five, 7}
	def match_type2(jokers, [c]) when jokers + c == 5, do: {:five, 7}
	def match_type2(jokers, [c,1]) when jokers + c == 4, do: {:four, 6}
	def match_type2(jokers, [c,2]) when jokers + c == 3, do: {:fullhouse, 5}
	def match_type2(jokers, [c,1,1]) when jokers + c == 3, do: {:three, 4}
	def match_type2(jokers, [c,2,1]) when jokers + c == 2, do: {:twopair, 3}
	def match_type2(jokers, [c,1,1,1]) when jokers + c == 2, do: {:onepair, 2}
	def match_type2(jokers, [1,1,1,1,1]), do: {:highcard, 1}


	# Normalize the card values and parse it all as a hex number
	def parse_order_1(cards) do
		String.replace(cards, ~r/[AKQJT]/, fn digit ->
			case digit do
				"T" -> "A"
				"J" -> "B"
				"Q" -> "C"
				"K" -> "D"
				"A" -> "E"
			end
		end)
		|> String.to_integer(16)
	end

	def parse_order(cards) do
		String.replace(cards, ~r/[AKQJT]/, fn digit ->
			case digit do
				"J" -> "1"
				"T" -> "A"
				"Q" -> "C"
				"K" -> "D"
				"A" -> "E"
			end
		end)
		|> String.to_integer(16)
	end

	def part1(input) do
		input
		|> Enum.sort_by(fn %{type: {_t, v}, order: o} -> v * 10000000 + o end)
		|> Enum.reduce({1, 0}, fn %{bid: bid}, {rank, sum} -> {rank + 1, sum + rank * bid} end)
	end

	def part2(input) do
		input
		|> Enum.sort_by(fn %{type: {_t, v}, order: o} -> v * 10000000 + o end)
		|> Enum.reduce({1, 0}, fn %{bid: bid}, {rank, sum} -> {rank + 1, sum + rank * bid} end)
	end

end

Aoc.run("data/sample.7")
Aoc.run("data/input.7")
