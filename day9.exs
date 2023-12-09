defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	def parse(input) do
		input
		|> String.trim
		|> String.split("\n")
		|> Enum.map(fn row -> String.split(row, " ") |> Enum.map(&String.to_integer(&1)) end)
		# |> IO.inspect
	end

	def part1(inputs) do
		inputs
		|> Enum.map(&next_sequence(&1))
		|> Enum.sum
	end

	def next_sequence(seq) do
		# IO.inspect(seq)
		l = List.last(seq)
		derived = derive(seq)
		case Enum.all?(derived, fn d -> d == 0 end) do
			true -> l
			false -> l + next_sequence(derived)
		end
	end

	def prev_sequence(seq) do
		# IO.inspect(seq)
		f = List.first(seq)
		derived = derive(seq)
		case Enum.all?(derived, fn d -> d == 0 end) do
			true -> f
			false -> f - prev_sequence(derived)
		end
	end

	# Returns the list of differences between each element
	def derive([a,b]), do: [b - a]
	def derive([a,b|more]), do: [b - a | derive([b|more])]

	def part2(inputs) do
		inputs
		|> Enum.map(&prev_sequence(&1))
		# |> IO.inspect
		|> Enum.sum
	end

end

Aoc.run("data/sample.9")
Aoc.run("data/input.9") # Part 1: 1584748276 is too high, correct was 1584748274. Part 2: 1026
