defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		# IO.inspect ["Part 2:", part2(parse(input))]
	end

	def parse(input) do
		String.trim(input)
		|> String.split(",")
	end

	def hash(input) do
		Enum.reduce(String.to_charlist(input), 0, fn code, current ->
			next = (current + code) * 17
			rem(next, 256)
		end)
	end

	def part1(input) do
		Enum.map(input, &hash(&1))
		|> IO.inspect
		|> Enum.sum
	end

	def part2(input) do
		input
	end

end

Aoc.run("data/sample.15")
Aoc.run("data/input.15")
