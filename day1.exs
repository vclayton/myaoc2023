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
	end

	def part1(input) do
		input
		|> Enum.map(fn i ->
			digits = String.replace(i, ~r{[^0-9]}, "")
			# IO.inspect(digits)
			String.first(digits) <> String.last(digits)
			|> String.to_integer
		end)
		|> Enum.sum
	end

	def part2(input) do
		input
		|> Enum.map(fn i ->
			digits = get_digits(i)
			# IO.inspect(digits)
			List.first(digits) * 10 + List.last(digits)
		end)
		|> Enum.sum
	end

	def get_digits(str, acc \\ []) do
		first = String.first(str)
		more = String.slice(str, 1..-1)
		cond do
			String.starts_with?(str, "one") -> get_digits(more, [1 | acc])
			String.starts_with?(str, "two") -> get_digits(more, [2 | acc])
			String.starts_with?(str, "three") -> get_digits(more, [3 | acc])
			String.starts_with?(str, "four") -> get_digits(more, [4 | acc])
			String.starts_with?(str, "five") -> get_digits(more, [5 | acc])
			String.starts_with?(str, "six") -> get_digits(more, [6 | acc])
			String.starts_with?(str, "seven") -> get_digits(more, [7 | acc])
			String.starts_with?(str, "eight") -> get_digits(more, [8 | acc])
			String.starts_with?(str, "nine") -> get_digits(more, [9 | acc])
			first >= "1" and first <= "9" -> get_digits(more, [String.to_integer(first) | acc])
			str == "" -> Enum.reverse(acc)
			true -> get_digits(more, acc)
		end
	end
end

Aoc.run("data/sample.1") # Expected: 142
# Aoc.run("data/sample.1.2") # Expected: 281. Crashes in part1, but works with part 2.
Aoc.run("data/input.1")

