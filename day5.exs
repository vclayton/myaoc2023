defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
	end

	# {seeds, %maps{type => ranges}}
	def parse(input) do
		input
		|> String.trim
		|> String.split("\n\n")
		|> case do [first|groups] ->
			{parse_seeds(first), Enum.reduce(groups, %{}, &parse_maps/2)}
		end
	end
	def parse_seeds(line) do
		String.replace(line, "seeds: ", "")
		|> String.split(" ")
		|> Enum.map(&String.to_integer(&1))
	end

	def parse_maps(input, maps) do
		[name|lines] = String.split(input, "\n")
		[from, _to] = name |> String.replace(" map:", "") |> String.split("-to-")
		Map.put(maps, String.to_atom(from), parse_map(lines))
	end

	def parse_map(lines) do
		lines
		|> Enum.map(fn l ->
			l
			|> String.split(" ")
			|> Enum.map(&String.to_integer(&1))
			|> case do [dst, src, len] ->
				%{
					src: Range.new(src, src+len),
					dst: Range.new(dst, dst+len),
					offset: dst-src
				}
			end
		end)
	end

	@conversions %{
		seed: :soil,
		soil: :fertilizer,
		fertilizer: :water,
		water: :light,
		light: :temperature,
		temperature: :humidity,
		humidity: :location
	}
	def convert(from, to, n, _maps) when from == to, do: n
	def convert(from, to, n, maps) do
		next = @conversions[from]
		convert(next, to, lookup({from, n}, maps), maps)
	end

	def lookup({from, n}, maps), do: do_mapping(n, maps[from])
	def do_mapping(n, ranges) do
		mapped_range = Enum.find(ranges, fn range -> n in range.src end)
		case mapped_range do
			nil -> n
			_ -> n + mapped_range.offset
		end
	end

	def part1(input) do
		{seeds, maps} = input
		|> IO.inspect
		seeds
		|> Enum.map(fn s ->
			convert(:seed, :location, s, maps)
		end)
		|> IO.inspect(charlists: :as_lists)
		|> Enum.min
	end

	def part2_brute(input) do
		{seeds, maps} = input
		_seed_ranges = Enum.chunk_every(seeds, 2)
		|> Enum.map(fn [start, len] -> Range.new(start, start+len-1) end)
		|> Stream.concat
		|> Stream.map(fn s ->
			convert(:seed, :location, s, maps)
		end)
		# |> IO.inspect(charlists: :as_lists)
		|> Enum.min
	end

	def part2(input) do
		{seeds, maps} = input
		inversions = Map.new(@conversions, fn {key, val} -> {val, key} end)
		|> IO.inspect
		Enum.chunk_every(seeds, 2)
		|> Enum.map(fn [start, len] -> Range.new(start, start+len-1) end)
		|> Enum.map(fn range ->
			# {convert(:seed, :location, range.first, maps), convert(:seed, :location, range.last, maps)}
			convert_range(:seed, :location, range, maps)
		end)
		# |> IO.inspect(charlists: :as_lists)
		# |> Enum.min
	end

	# Returns a list of values that this range could map to
	def convert_range(from, to, r, _maps) when from == to, do: r
	def convert_range(from, to, r, maps) do
		next = @conversions[from]
		convert(next, to, lookup({from, r.first}, maps), maps)
	end

end

Aoc.run("data/sample.5")
# Aoc.run("data/input.5")

