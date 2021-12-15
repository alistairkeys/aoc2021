import std/[strutils, sugar, sets, sequtils]

# https://adventofcode.com/2021/day/13

type
  Instruction = object
    points: seq[tuple[x, y: int]]
    folds: seq[tuple[axis: char, value: int]]
    biggestX, biggestY: int

proc parseInstructions(filename: string): Instruction =
  for l in filename.lines:
    if l.contains ',':
      let parts = l.split ","
      result.points.add (parts[0].parseInt, parts[1].parseInt)
    elif l.contains "fold along ":
      let parts = l.split("fold along ")[1].split('=')
      result.folds.add (parts[0][0], parts[1].parseInt)

  result.biggestX = max result.points.mapIt(it.x)
  result.biggestY = max result.points.mapIt(it.y)

proc print(instructions: Instruction) =

  var grid: seq[string]
  for _ in 0 .. instructions.biggestY:
    grid.add repeat('.', instructions.biggestX + 1)

  for pt in instructions.points:
    grid[pt.y][pt.x] = '#';

  var outputFile = open("../data/day13_output.txt", fmWrite)
  defer: close(outputFile)
  for s in grid:
    outputFile.writeLine s

proc doFold(instruction: var Instruction, foldIndex: int) =

  let fold = instruction.folds[foldIndex]

  if fold.axis == 'x':
    instruction.points.applyIt((x: if it.x <
        fold.value: it.x else: it.x - ((it.x - fold.value) * 2), y: it.y))
    instruction.biggestX -= fold.value
  else:
    instruction.points.applyIt((x: it.x, y: if it.y <
        fold.value: it.y else: it.y - ((it.y - fold.value) * 2)))
    instruction.biggestY -= fold.value

proc foldOnce(instruction: var Instruction) =
  instruction.doFold 0

proc foldAll(instruction: var Instruction) =
  for idx, _ in instruction.folds:
    instruction.doFold idx

proc countDots(instructions: Instruction): int =
  let distinctPoints = collect:
    for pt in instructions.points:
      {pt.y * (instructions.biggestX + 1) + pt.x}
  result = distinctPoints.len

proc part1(filename: string): int =
  var instructions = parseInstructions filename
  foldOnce instructions
  countDots instructions

proc part2(filename: string) =
  var instructions = parseInstructions filename
  foldAll instructions
  print instructions

when isMainModule:
  doAssert part1("../data/day13_example.txt") == 17
  echo part1("../data/day13_input.txt")

  part2("../data/day13_input.txt") # Answer is in the day13_output.txt file
