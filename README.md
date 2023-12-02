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
	My first answer, 254, was too low. Oh, duh! I was summing the color counts for each game, when really I should be taking the *max of each color*.
</details>

#### Part 2
Good thing my (eventual) approach on part 1 left me with the exact data needed for part 2. It was literally 2 lines to extract and sum the values.
