defmodule Aoc do
	def run(inputFile) do
		IO.puts(["Reading ", inputFile])
		{:ok, input} = File.read(inputFile)
		IO.inspect ["Part 1:", part1(parse(input))]
		IO.inspect ["Part 2:", part2(parse(input))]
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
		# |> IO.inspect
		|> Enum.sum
	end

	def str_to_integer(""), do: 0
	def str_to_integer(str), do: String.to_integer(str)

	def parse_step(step) do
		given = Regex.named_captures(~r/(?<lbl>[a-zA-Z]+)(?<op>[=-])(?<val>[0-9]*)/, step)
		%{
			lbl: given["lbl"],
			op: given["op"],
			val: str_to_integer(given["val"]),
			hash: hash(given["lbl"])
		}
	end

	def if?(test, t, _f) when test, do: t
	def if?(test, _t, f) when not test, do: f

	def process_step(op, lbl, val, b) do
		box = if?(is_nil(b), [], b)
		IO.inspect({op, lbl, val, box})
		case op do
			"=" -> List.keystore(box, lbl, 0, {lbl, val})
			"-" -> List.keydelete(box, lbl, 0)
		end
	end

	def part2(input) do
		steps = Enum.map(input, &parse_step(&1))
		processed = Enum.reduce(steps, %{}, fn step, boxes ->
			{oldbox, newmap} = Map.get_and_update(boxes, step.hash, fn current -> {current, process_step(step.op, step.lbl, step.val, current)} end)
			newmap
		end)

		# Now add up the focusing power of all the lenses
		Enum.map(processed, fn {box, lenses} ->
			Enum.map(Enum.with_index(lenses), fn {{lbl, val}, slot} ->
				(box + 1) * (slot + 1) * val
			end)
		end)
		|> List.flatten
		|> Enum.sum

	end

end

Aoc.run("data/sample.15")
Aoc.run("data/input.15")
