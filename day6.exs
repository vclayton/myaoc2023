defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# [{time, dist}]
	def parse(input) do
		input
		|> String.trim
		|> String.replace(~r/(Time|Distance):\s*/, "")
		|> String.split("\n")
		|> Enum.map(fn row ->
			String.split(row, ~r/[^0-9]+/)
			|> Enum.map(fn n -> String.to_integer(n) end)
		end)
		|> List.zip
	end
	def part1(input) do
		input
		|> Enum.map(&count_wins(&1))
		|> Enum.product
	end

	def count_wins({time, dist}) do
		wins = for h <- 0..time, won? = (h * (time - h)) > dist, do: won?
		IO.inspect(wins)
		|> Kernel.length
	end

	def part2(input) do
		{t, d} = Enum.unzip(input)
		time = String.to_integer(Enum.map(t, &Integer.to_string(&1)) |> Enum.join)
		dist = String.to_integer(Enum.map(d, &Integer.to_string(&1)) |> Enum.join)
		IO.inspect({time, dist})
		count_wins({time, dist})
	end

end

Aoc.run("data/sample.6")
Aoc.run("data/input.6")

