import std/[sequtils, strutils, math]

# https://adventofcode.com/2021/day/6

proc part1(filename: string, days: int): int =

  var fishies = filename.readFile.split(",").map(parseInt)

  for day in 1 .. days:
    let newEntries = fishies.countIt(it == 0)
    fishies.applyIt(if it == 0: 6 else: it - 1)
    if newEntries > 0:
      let oldLen = fishies.len
      fishies.setLen(fishies.len + newEntries)
      for i in oldLen .. fishies.high:
        fishies[i] = 8

  result = fishies.len

proc part2(filename: string, days: int): uint64 =

  # I take absolutely no credit for this solution to part 2.  I shamelessly
  # nicked it from a Reddit comment:
  # https://old.reddit.com/r/adventofcode/comments/r9z49j/2021_day_6_solutions/hninf6a/

  var fishState: array[9, uint64]
  for x in filename.readFile.split(",").map(parseInt):
    fishState[x] += 1

  for _ in 0 ..< days:
    var fish0 = fishState[0]
    for j in 0 .. 7:
      fishState[j] = fishState[j + 1]
    fishState[6] += fish0
    fishState[8] = fish0

  result = sum fishState

when isMainModule:
  doAssert part1("../data/day06_example.txt", 18) == 26
  doAssert part1("../data/day06_example.txt", 80) == 5934
  echo part1("../data/day06_input.txt", 80)

  doAssert part2("../data/day06_example.txt", 256) == 26984457539'u64
  echo part2("../data/day06_input.txt", 256)
