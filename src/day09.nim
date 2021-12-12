import std/[sequtils, strutils, math]

# https://adventofcode.com/2021/day/9

proc part1(filename: string): int =

  const dummyValue = int.high

  # The heights seq has dummy values for the first and last row/column to avoid
  # lots of 'if' checks on the borders.
  var heights: seq[seq[int]]

  proc addHeightRow(l: string) =
    var row = l.toSeq.mapIt(parseInt $it)
    heights.add( @[dummyValue] & row & @[dummyValue])

  var file = open(filename, fmRead)
  defer: close(file)

  var s = file.readLine
  heights.add newSeqWith(s.len + 2, dummyValue)
  addHeightRow s

  while not endOfFile(file):
    addHeightRow file.readLine

  heights.add newSeqWith(s.len + 2, dummyValue)

  var riskLevels: seq[int]

  for row in 1 ..< heights.high:
    for col in 1 ..< heights[row].high:
      let here = heights[row][col]
      if here < min([heights[row][col - 1], heights[row][col + 1], heights[row -
          1][col], heights[row + 1][col]]):
        riskLevels.add here + 1

  result = sum riskLevels

#proc part2(filename: string): int =
#  result = ??

when isMainModule:
  doAssert part1("../data/day09_example.txt") == 15
  echo part1("../data/day09_input.txt")

  #doAssert part2("../data/day09_example.txt") == 1134
  #echo part2("../data/day09_input.txt")
