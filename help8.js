let at = [208, 491, 238, 220, 123, 147]; // n, P, n, n, n, n
let skip = [73, 71, 43, 61, 158, 134]; // P, P, P, P, n, n

let sums = [281, 562, 281, 281, 281, 281]; // Hmm... 562 is 2 * 281

//for(let n = 1; n < 10; n++) {
while (true) {
	if (at[0]==at[1]==at[2]==at[3]==at[4]==at[5]) {
		console.log('Woot!', at);
		process.exit(1);
	}

	let max = Math.max(...at);
	for (a = 0; a < 6; a++) {
		while (at[a] < max) {
			at[a] += skip[a];
		}
	}
}

console.log(at);
