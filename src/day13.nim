import std/[strutils, sugar, sets, sequtils]

# https://adventofcode.com/2021/day/13

proc part1(filename: string): int =

  var points: seq[tuple[x, y: int]]
  var folds: seq[tuple[axis: char, value: int]]

  for l in filename.lines:
    if l.contains ',':
      let parts = l.split ","
      points.add (parts[0].parseInt, parts[1].parseInt)
    elif l.contains "fold along":
      let parts = l.split("fold along")[1].split('=')
      folds.add (parts[1][0], parts[1].parseInt)

  let biggestX = max points.mapIt(it.x)
  let biggestY = max points.mapIt(it.y)

  for fold in folds:
    if fold.axis == 'x':
      points.applyIt((x: it.x, y: if it.y <
          biggestY div 2: it.y else: biggestY - it.y))
    else:
      points.applyIt((x: if it.x < biggestX div 2: it.x else: biggestX - it.x, y: it.y))

  let distinctPoints = collect:
    for pt in points: {pt.y * biggestX + pt.x}

  result = distinctPoints.len

#proc part2(filename: string): int =
  #result = ??

when isMainModule:
  doAssert part1("../data/day13_example.txt") == 17
  echo part1("../data/day13_input.txt")

  #doAssert part2("../data/day13_example.txt") == ??
  #echo part2("../data/day13_input.txt")
