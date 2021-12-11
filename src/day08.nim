import std/[sequtils, strutils]

# https://adventofcode.com/2021/day/8

proc part1(filename: string): int =
  for l in filename.lines:
    result += l.split(" | ")[1].splitWhitespace.countIt(it.len in {2, 4, 3, 7})

#proc part2(filename: string): int =
  #result = ??

when isMainModule:
  doAssert part1("../data/day08_example.txt") == 26
  echo part1("../data/day08_input.txt")

  #doAssert part2("../data/day08_example.txt") == 5353
  #echo part2("../data/day08_input.txt")
