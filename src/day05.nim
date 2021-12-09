import std/[sequtils, strscans, tables]

# https://adventofcode.com/2021/day/5

const
  squaresPerRowOrCol = 999

iterator range(a, b: int): int =
  ## The `..` iterator doesn't run if the first parameter is greater than the
  ## second (i.e. it'd be countdown instead of countup).  This iterator reorders
  ## the input to allow this.
  let aa = min(a, b)
  let bb = max(a, b)
  for i in aa .. bb: yield i

type
  Direction = enum horizontal, vertical, diagonal

proc getOverlaps(filename: string, directions: set[Direction]): int =

  # The overlap counts are flattened to 1-D to make storage simpler
  template coordsToIdx(x, y: int): int = ((y * squaresPerRowOrCol) + x)

  var counts: CountTable[int]

  for line in filename.lines:
    var fromX, fromY, toX, toY: int
    if not line.scanf("$i,$i -> $i,$i", fromX, fromY, toX, toY):
      raise newException(ValueError, "Cannot parse input line: " & line)

    if horizontal in directions and fromY == toY:
      for x in range(fromX, toX):
        counts.inc coordsToIdx(x, fromY)

    if vertical in directions and fromX == toX:
      for y in range(fromY, toY):
        counts.inc coordsToIdx(fromX, y)

    if diagonal in directions and (abs(toX - fromX) == abs(fromY - toY)):
      var thisX = fromX
      var thisY = fromY
      let xStep = if fromX < toX: 1 else: -1
      let yStep = if fromY < toY: 1 else: -1
      while true:
        counts.inc coordsToIdx(thisX, thisY)
        if thisX == toX and thisY == toY:
          break
        inc thisX, xStep
        inc thisY, yStep

  result = counts.values.countIt(it > 1)

proc part1(filename: string): int =
  result = getOverlaps(filename, {horizontal, vertical})

proc part2(filename: string): int =
  result = getOverlaps(filename, {horizontal, vertical, diagonal})

when isMainModule:
  doAssert part1("../data/day05_example.txt") == 5
  echo part1("../data/day05_input.txt")

  doAssert part2("../data/day05_example.txt") == 12
  echo part2("../data/day05_input.txt")
