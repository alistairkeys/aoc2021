import std/[sequtils, strutils, math, algorithm, intsets]

# https://adventofcode.com/2021/day/9

type
  LowPoint = object
    col, row, height: int

proc loadHeightMap(filename: string): seq[seq[int]] =

  const dummyValue = 9

  template addHeightRow(l: string) =
    var row = l.toSeq.mapIt(parseInt $it)
    result.add(@[dummyValue] & row & @[dummyValue])

  var file = open(filename, fmRead)
  defer: close(file)

  # The result has dummy border values added to avoid requiring 'if' checks
  # later in the code.

  var s = file.readLine
  result.add newSeqWith(s.len + 2, dummyValue)
  addHeightRow s

  while not endOfFile(file):
    addHeightRow file.readLine

  result.add newSeqWith(s.len + 2, dummyValue)

proc findLowPoints(heights: seq[seq[int]]): seq[LowPoint] =
  for row in 1 ..< heights.high:
    for col in 1 ..< heights[row].high:
      let here = heights[row][col]
      if here < min([heights[row][col - 1], heights[row][col + 1], heights[row -
          1][col], heights[row + 1][col]]):
        result.add LowPoint(row: row, col: col, height: here)

proc part1(filename: string): int =
  var heights = loadHeightMap filename
  result = sum findLowPoints(heights).mapIt(it.height + 1)

proc part2(filename: string): int =
  var
    heights = loadHeightMap filename
    lowPoints = findLowPoints heights
    basins: seq[int]

  func coordToIdx(r, c: int): int = ((r * heights[0].len) + c)

  for lp in lowPoints:
    var
      count = 0
      checked: IntSet
      stack: seq[tuple[r, c: int]]

    proc addSquareToCheck(r, c: int) =
      if coordToIdx(r, c) notin checked:
        stack.add (r, c)
        checked.incl coordToIdx(r, c)

    addSquareToCheck lp.row, lp.col
    while stack.len > 0:
      let where = stack.pop
      if heights[where.r][where.c] < 9:
        inc count
        addSquareToCheck(where.r - 1, where.c)
        addSquareToCheck(where.r + 1, where.c)
        addSquareToCheck(where.r, where.c - 1)
        addSquareToCheck(where.r, where.c + 1)

    basins.add count

  result = basins.sorted[^3..^1].foldl(a * b, 1)

when isMainModule:
  doAssert part1("../data/day09_example.txt") == 15
  echo part1("../data/day09_input.txt")

  doAssert part2("../data/day09_example.txt") == 1134
  echo part2("../data/day09_input.txt")
