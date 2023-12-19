defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		# IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
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
	def parse_node(blah) do
		[[name],[left],[right]] = Regex.scan(~r/([0-9A-Z]+)/, blah, capture: :all_but_first)
		{name, left, right}
	end

	def part1({path, nodes}) do
		IO.inspect(nodes)
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

	def find_next(from, which, nodes) do
		{left, right} = Map.get(nodes, from)
		case which do
			"L" -> left
			"R" -> right
		end
	end

	def follow_path(start, paths, nodes) do
		path_len = length(paths)
		{repeat, history} = Enum.reduce_while(Stream.cycle(paths), {1, start, []}, fn which, {n, at, history} ->
			done = String.last(at) == "Z"
			next = find_next(at, which, nodes)
			round = {n, at}
			repeat = List.keyfind(history, at, 1, false)
			path_end = rem(n, path_len) == 0
			# IO.inspect({n, path_len, path_end})
			if path_end and repeat != false do
				{:halt, {repeat, Enum.reverse([round | history])}}
			else
				{:cont, {n + 1, next, [round | history]}}
			end
		end)

		{offset, _where} = repeat
		cycle_length = length(history) - offset
		{:repeat, offset, cycle_length, path_len}
	end

	def part2({path, nodes}) do
		IO.inspect(nodes)
		starts = for {n, _} <- nodes, String.last(n) == "A", do: n
		IO.inspect(starts)
		paths = String.codepoints(path)

		# The brute force approach
		# {final, count} = Enum.reduce_while(Stream.cycle(paths), {starts, 0}, fn which, {from, n} ->
		# 	IO.inspect([which, {from, n}])
		# 	if Enum.all?(from, fn f -> String.last(f) == "Z" end) do
		# 		{:halt, {from, n}}
		# 	else
		# 		nexts = Enum.map(from, fn f ->
		# 			{left, right} = Map.get(nodes, f)
		# 			case which do
		# 				"L" -> left
		# 				"R" -> right
		# 			end
		# 		end)
		# 		{:cont, {nexts, n+1}}
		# 	end
		# end)


		# Find where each of the start paths repeats. {:repeat, starting_at, repeat_length, path_length}
		repeats = Enum.map(starts, fn start -> follow_path(start, paths, nodes) end)
		offsets = Enum.map(repeats, fn {_, o, _, _} -> o end)
		skips = Enum.map(repeats, fn {_, o, _, _} -> o end)
		# Enum.reduce_while(1..10, offsets,
	end

end

# Aoc.run("data/sample.8.2")
Aoc.run("data/input.8") # Part 2: 157922 is too low
