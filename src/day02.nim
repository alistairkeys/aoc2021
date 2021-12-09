import std/[strutils]

# https://adventofcode.com/2021/day/2

proc part1(filename: string): int =
  var depth, horizontal = 0

  for line in filename.lines:
    let parts = line.splitWhitespace
    case parts[0]
      of "forward": inc horizontal, parts[1].parseInt
      of "up": dec depth, parts[1].parseInt
      of "down": inc depth, parts[1].parseInt

  result = depth * horizontal

proc part2(filename: string): int =
  var depth, horizontal, aim = 0

  for line in filename.lines:
    let parts = line.splitWhitespace
    case parts[0]
      of "forward":
        inc horizontal, parts[1].parseInt
        inc depth, aim * parts[1].parseInt
      of "up": dec aim, parts[1].parseInt
      of "down": inc aim, parts[1].parseInt

  result = depth * horizontal

when isMainModule:
  doAssert part1("../data/day02_example.txt") == 150
  echo part1("../data/day02_input.txt")

  doAssert part2("../data/day02_example.txt") == 900
  echo part2("../data/day02_input.txt")
