defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		# IO.inspect ["Part 2:", part2(parse(input))]
	end

	# {instructions, nodes}
	def parse(input) do
		input
		|> String.trim
		|> String.split("\n\n")
		|> case do [instructions, nodes] ->
			{instructions, Enum.reduce(String.split(nodes, "\n"), %{}, &parse_nodes/2)}
		end
	end

	def parse_nodes(input, nodes) do
		{node, left, right} = parse_node(input)
		Map.put(nodes, node, {left, right})
	end
	def parse_node(<<name::size(3), " = (", left::size(3), " ", right::size(3), ")">>), do: {name, left, right}
	def parse_node(blah) do
		[[name],[left],[right]] = Regex.scan(~r/([A-Z]+)/, blah, capture: :all_but_first)
		{name, left, right}
	end

	def part1({path, nodes}) do
		find_path("AAA", "ZZZ", path, nodes)
		|> IO.inspect
		|> length
	end

	def find_path(to, to, _, _), do: []
	def find_path(from, to, <<which,path::binary>>, nodes) do
		{left, right} = Map.get(nodes, from)
		IO.inspect(which);
		next = case which do
			?L -> left
			?R -> right
		end
		[next | find_path(next, to, <<path::binary,which>>, nodes)]
	end

	def part2(input) do
		input
	end

end

Aoc.run("data/sample.8")
Aoc.run("data/input.8")
