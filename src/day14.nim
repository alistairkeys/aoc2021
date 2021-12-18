import std/[strutils, tables]

# https://adventofcode.com/2021/day/14

type
  PolymerTemplate = object
    input: string
    pairs: Table[string, char]

proc loadTemplate(filename: string): PolymerTemplate =
  var file = open(filename, fmRead)
  defer: close(file)

  result.input = file.readLine
  discard file.readLine
  while not endOfFile(file):
    let l = file.readLine.split(" -> ")
    result.pairs[l[0]] = l[1][0]

proc part1(filename: string): int =

  let t = loadTemplate filename
  var polymer = t.input

  for loop in 0 ..< 10:
    var nextPolymer = newStringOfCap(polymer.len * 2)
    var nextIdx = 0
    for idx in 0 ..< polymer.len - 1:
      nextPolymer[nextIdx] = polymer[idx]
      nextPolymer[nextIdx+1] = t.pairs[polymer[idx .. idx + 1]]
      inc nextIdx, 2
    nextPolymer[nextIdx] = polymer[^1]
    nextPolymer.setLen nextIdx + 1
    polymer = nextPolymer

  var count: CountTable[char]
  for ch in polymer: count.inc ch

  result = count.largest.val - count.smallest.val

#proc part2(filename: string): int =
  #result = 0

when isMainModule:
  doAssert part1("../data/day14_example.txt") == 1588
  echo part1("../data/day14_input.txt")

  #doAssert part2("../data/day14_example.txt") == 2188189693529
  #echo part2("../data/day14_input.txt")
