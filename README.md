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
<details>
	<summary>Better Comprehension</summary>
To count the number of wins I used a list comprehension that basically mapped the {time, dist} to a boolean "win" value, then used Enum.filter to get just the wins:
```
def count_wins({time, dist}) do
	wins = for h <- 0..time, do: (h * (time - h)) > dist
	Enum.filter(wins, fn t -> t end)
	|> Kernel.length
	|> IO.inspect
end
```

But that's lame. I wanted to use the comprehension itself to do the filtering. I know you can give it filters but I didn't realise I could put the logic itself there.
First thought was like `wins = for h <- 0..time, won != false, do: won = (h * (time - h)) > dist` but it didn't work right.
Eventually learned I could put the calculation itself in the filter clause and just return the resulting value like so:
```
for h <- 0..time, won? = (h * (time - h)) > dist, do: won?
```

And in hindsight it turns out this works just fine also.
```
Enum.filter(0..time, fn h -> (h * (time - h)) > dist end)
```
</details>


### Day 7
Going to parse these hands into maps, calculate the type with pattern matching probably, and calculate the sub-order by maybe just pretend the card string represents a base-14 integer.
#### Part 1
<details>
	<summary>Sorting and matching</summary>
I wound up sorting them by giving each hand type a number and multiplying it by 10 million, and adding the sub-order that was parsed as a hex value.
Also, I calculated the hand type by counting the frequency of each letter, then pattern matching like this
```
def match_type([5]), do: {:five, 7}
def match_type([4,1]), do: {:four, 6}
def match_type([3,2]), do: {:fullhouse, 5}
def match_type([3,1,1]), do: {:three, 4}
def match_type([2,2,1]), do: {:twopair, 3}
def match_type([2,1,1,1]), do: {:onepair, 2}
def match_type([1,1,1,1,1]), do: {:highcard, 1}
```
</details>

#### Part 2
Ugh. That pattern matching from part 1 will have to be heavily modified. Maybe step through all of the cards that might be replaced by a Joker and see if they match any patterns, then take the best one?
Also I was sad to have to duplicate so much of the code because parsing it all is _mostly_ the same as part 1 but not. I wonder if some kind of variable could be used to indicate which part we're on. I guess ETS is the answer, which is less simple than I'd hoped.
<details>
	<summary>Sorting and matching again</summary>
By taking the same per-letter frequency count as part 1 and just remove the jokers from that, I could pass it separately to the matching function and make handy use of guard clauses
```
	# Given (NumberOfJokers, [numbers of each non-joker])
	def match_type2(5, _), do: {:five, 7}
	def match_type2(jokers, [c]) when jokers + c == 5, do: {:five, 7}
	def match_type2(jokers, [c,1]) when jokers + c == 4, do: {:four, 6}
	def match_type2(jokers, [c,2]) when jokers + c == 3, do: {:fullhouse, 5}
	def match_type2(jokers, [c,1,1]) when jokers + c == 3, do: {:three, 4}
	def match_type2(jokers, [c,2,1]) when jokers + c == 2, do: {:twopair, 3}
	def match_type2(jokers, [c,1,1,1]) when jokers + c == 2, do: {:onepair, 2}
	def match_type2(jokers, [1,1,1,1,1]), do: {:highcard, 1}
```
The only surprise was finding out that there was a 5-joker hand in the dataset.
</details>

### Day 8
Github markdown doesn't seem to be doing all the code formatting I want. Whatever.
This exercise looks like binary tree parsing and traversal. I decided to use binary matching for extracting the path data from each line, but it didn't work like I wanted. Regex it is.

#### Part 1
I did use binary match and concat to get the rotating first element of the instruction list. So yay. Not sure I need to know the entire path, just the length, but for now it doesn't hurt to track it.

#### Part 2
Yay, list comprehension worked for filtering the list of starting nodes. Now maybe `Enum.reduce_while` will be the perfect fit for following each path until we're good.
<details>
	<summary>Spoilers</summary>
OK, got something working on the sample, using reduce_while and also Stream.cycle to iterate through the instructions list this time. Sure is taking its time on the real data...
I wonder if it's just slow to lookup the node in the map each time? Like maybe actually storing it as a graph would make traversal faster?

OK, after letting it run for 25 hours I think I have an alternative approach. The number of starting nodes is 5 (in my data). The instruction pattern is repeating, so the pattern of nodes visited along the path should be repeating too. I can look at each of the 5 starting points and run it until it starts to repeat, giving me a step count for that path.
</details>


### Day 9
#### Part 1
First answer was too high. I think because I tried a shortcut of deriving until the last element in the derived list was 0, rather than until the entire list was 0.

Hmm, especially since the inputs contain negative numbers also. Yep, checking the entire list fixed it.

#### Part 2
Yay, a simple change to which element gets examined and a flip in the arithmetic.


### Day 14
#### Part 1
I started out with the grid made of tuples I was trying for day 10. That worked fine for adding up the numbers, but for the "tilting" I decided that storing each column as a list would be cleaner.
First I made a function that adds up the values of the rocks in a column and tested it on the pre-tilted sample data.
Then I made a function that tilts a column by one time step, and I repeat it n times on a column on length n. Did that for each column, then summed up all the results.
Silver star, first try!

#### Part 2
<details>
		<summary>Spoilers</summary>
To make the "spin cycle" I can take what I've got from part 1, and need to be able to make new column orientations from an existing oriantation.
Also because of the large number of cycles asked for I suspect the rock pattern will eventually be repeating. Probably like Day 8 Part 2 is probably supposed to work, since the naive "just keep running" approach _still_ hasn't finished after 261 hours of CPU time.
So I'll keep a snapshot of the state after each spin (maybe as a checksum or hash?) and compare it against a list of previous states until I see a repeat. Then divide the cycle number into 1000000000 and add the remainder or something to find the right snapshot.
Rotating the grid looks like transposing and then reversing the column order. Spin function just tilts and rotates 4 times.

Sample data matches example after 1,2, and 3 cycles. So I'll crank it up to 1 billion and let it crunch while I read about algorithms for detecting repeating patterns...
I started dumping out the cycle number and md5 hash of the grid for the first 50 cycles, and by eyeballing it can see that (for sample input) it repeats every 7 cycles, with the first 3 never repeated.
And since a given pattern will always spin into the same next pattern I just need to check to see if we've _ever_ seen this pattern before to know that we're starting to repeat.
So given cycle length _c_, starting at offset _o_, getting element _n_ is the maybe same as getting element ((_n_ - _o_) mod _c_ + _o_)?

Yay, gold star first try!
</details>


### Day 15
#### Part 1
Simple parsing, simple algorithm. First try.
#### Part 2
Again, fairly straightforward. It sure was nice to be able to use the List.keystore and List.keydelete functions for processing the list of operations.
