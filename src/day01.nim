import std/[strutils, sequtils]

# https://adventofcode.com/2021/day/1

proc part1(filename: string): int =
  let values = filename.lines.toSeq.mapIt(it.parseInt)
  for idx in 1..values.high:
    if values[idx-1] < values[idx]:
      inc result

proc part2(filename: string): int =
  let values = filename.lines.toSeq.mapIt(it.parseInt)
  var window = values[0] + values[1] + values[2]
  for idx in 3..values.high:
    if window + values[idx] - values[idx - 3] > window:
      inc result
    inc window, values[idx] - values[idx - 3]

when isMainModule:
  doAssert part1("../data/day01_example.txt") == 7
  echo part1("../data/day01_input.txt")

  doAssert part2("../data/day01_example.txt") == 5
  echo part2("../data/day01_input.txt")
