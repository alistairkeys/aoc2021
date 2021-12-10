import std/[sequtils, strutils, algorithm]

# https://adventofcode.com/2021/day/7

proc part1(filename: string): int =
  let values = filename.readFile.split(",").map(parseInt).sorted
  values.foldl(a + abs(b - values[values.len div 2]), 0)

#proc part2(filename: string): int =
  #result = ??

when isMainModule:
  doAssert part1("../data/day07_example.txt") == 37
  echo part1("../data/day07_input.txt")

  #doAssert part2("../data/day07_example.txt") == 168
  #echo part2("../data/day07_input.txt")
