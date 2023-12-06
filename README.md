# My Advent Of Code 2023

This is the code I wrote to solve the coding challenges for the Advent of Code 2023. I'm still trying to learn Elixir, and _hoping_ to not have to use the crutch I did last year of first solving in JS and then porting my solutions over to Elixir.
Probably not going to be "idiomatic" elixir, but anything is better than nothing.

## Running elixir from docker
Installing and updating elixir natively can sometimes be a pain, so i'd like to avoid that for now.
Using the official elixir docker image I can run either the REPL or a .exs script, and I made scripts that just wrap the proper invocations.
`elixir-run` is `docker run -it --rm --name elixir-inst1 -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir elixir $@`
and `iex` is `docker run -it --rm elixir`

### Day 1
After parsing the input into a list of strings, a straightforward approach should work, but the sum (for my input, 55211) is apparently too high. Seems the right ballpark though for the sum of 1003 2-digit numbers.
Worked correctly with the sample input... :(
...And it turned out to be a problem in the input file. First time I copied/pasted from the browser, second time used the Save Link As. Now I know better. Also now it's a nice round 1000 lines of input.
#### Part 1
<details>
	<summary>Spoiler</summary>
	Straightforward approach: For each line remove everything that isn't a digit and concat the first with last. Sum the resulting list.
</details>

#### Part 2
<details>
	<summary>Spoiler</summary>
	Tried just expanding the regex from part1 to include words, but the sample data had some words overlapping, and I couldn't figure out a simple way to make a regex capture them all.
	So I changed it to scan through the string and see if it starts with a digit word, then remove the first character and recurse.
</details>


### Day 2
#### Part 1
Each line of input has the game number followed by the list of cube counts, which is delimited but not terminated with a semicolon. The colors are not given in any particular order.
I'll parse the lines into a tuple of `{gameId, [cubeCounts, ...]}` then make a function that sums the cubeCounts and appends them to the game tuple, then filter based on bag limits.

While working I switched to a map for cube counts like `%{"red" => 0, "green" => 0, "blue" => 0}` instead of a list, because then parsing could go ahead and add up the cube counts per game in whatever order they appear. I do _not_ have a good handle on any of this, and spent a lot of time in the docs and cheatsheets for Regex, Map, Enum, and pattern matching.
<details>
	<summary>Spoiler</summary>
	My first answer, 254, was too low. Oh, duh! I was summing the color counts for each game, when really I should be taking the **max of each color**.
</details>

#### Part 2
Good thing my (eventual) approach on part 1 left me with the exact data needed for part 2. It was literally 2 lines to extract and sum the values.

### Day 3
I figure I'll parse the input into a list of numbers with the positions, and a list of symbols with their positions, then run each list against the other doing basic "collision detection."
#### Part 1
<details>
	<summary>Spoiler</summary>
	That worked with the sample data, but my answer on real input was too low. Then I realized I wasn't handing cases like "123*456" correctly when parsing. Fixed and tried again, but this time I was too high.
	Then realized I had an off-by one in my check for "is this a part number" when comparing it's boundaries against the symbols' positions.
	Was `sym_x >= x1 - 1 and sym_x <= x2 + 1 and sym_y >= y - 1 and sym_y <= y + 1` but should be
	`sym_x >= x1 - 1 and sym_x < x2 + 1 and sym_y >= y - 1 and sym_y <= y + 1`
	All good now.
</details>

#### Part 2
Didn't work at first, lining up symbols with numbers again.
<details>
	<summary>Spoiler</summary>
	I broke out a separate function for `is_adjacent?(symbol, number)`. In order to not be calculating String.length as often I'm storing the x1 and x2 values in the "number" tuples now.
	Tested the is_adjacent? function by refactoring Part 1 to use it and verify the result. Worked great for part 2.
</details>


### Day 4
Looks similar to day 3, being a "make two lists and compare the items" setup.
#### Part 1
Yep. As usual, parsing strings into numbers was the hardest part.
#### Part 2
Ugh. Updating maps by iterating unrelated lists (e.g. a range) is not simple in elixir, as far as I can tell. Maybe I should go back to using just a list. Hmm, and expanding it into a bigger list, or a nested list that gets flattened?
<details>
	<summary>Spoiler</summary>
	OK, the mathy trick is that the number of bonus cards goes exponential because there's copies of copies making copies.
	After a lot of back and forth with maps vs lists and nested reduces, I landed on what was ultimately a simpler approach.
	Each card knows how many wins it has, so I iterate through the list and pass along an extra list that counts how many bonus copies of this card we've gotten from previous wins. It's initialized with 0 for each card. As I iterate, I pop the first element off the bonus list, which will be for the current card. Then I can add in the bonus copies for this card, and then use that to increment the next n elements of the bonus list.
</details>


### Day 5
Mapping and ranges. Maybe store the ranges as a source and offset? Whatever, parsing comes first, as usual.
Parsing worked out to having a map of each source type to a list of ranges, where each range is a map of src, dst, and offset. Src and dst are elixir Range structures, and offset is just an integer.
Using actual Range structures lets the lookup function be really easy.
#### Part 1
<details>
	<summary>Spoiler</summary>
	With a table of {from: to} type conversions I could make a `convert(from, to, n, maps)` function that does a single conversion then recursed until from == to.
	Part 1 calls `convert(:seed, :location, s, maps)` for each seed, then returns the min of the result.
</details>

#### Part 2
<details>
	<summary>Spoiler</summary>
	Looks like it _should_ just be the exact same as part 1 with a slight modification to the seed inputs. `Range` to the rescue again!
	**BOOM** OOM Killer. Note to self: don't flatten the list of Ranges, they're too big. That's why Range is streamable. Good time to learn about the Stream module.

	Hmm. Stream fixes the memory explosion, now we see if I can wait out the time explosion or if I have to change the algorithm to be more clever...
	...only 1.7 billion seeds to brute force...
	...any time now...
	...I'm not trying for first place, just an answer...

	Maybe I could approach it by trying to test just the edges of the ranges. That could involve a treeish search, since each seed range could map into multiple soil ranges, each of which could map into multiple fertilizer ranges, etc.

	Rambling: The mappings are a set of ranges and offsets, where an input outside any of the explicit ranges has an implicit offset of 0.
	For each mapping we could find the range that will have the lowest offset and just ignore the rest when exploring the space?
</details>

### Day 6
Parsed input into a list of `{time, dist}` tuples and fiddled around with list comprehensions for this one. The actual calculations were (for Part 1) trivial. Part 2 of course required... Oh. Nothing fancy at all, for once. Just transform the input differently.

