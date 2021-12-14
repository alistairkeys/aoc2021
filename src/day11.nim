import std/[sequtils, strutils, intsets]

# https://adventofcode.com/2021/day/11

proc loadHeightMap(filename: string): seq[seq[int]] =
  var file = open(filename, fmRead)
  defer: close(file)
  while not endOfFile(file):
    result.add file.readLine.toSeq.mapIt(parseInt($it))

proc runStep(energy: var seq[seq[int]]): int {.discardable.} =

  block increaseEnergyByOne:
    for row in energy.mitems:
      row.applyIt(it + 1)

  block doFlashes:
    template coordToIdx(r, c: int): int = ((r * energy[0].len) + c)
    template incEnergy(rr, cc: int) =
      if rr in 0..9 and cc in 0..9:
        inc energy[rr][cc]

    var
      checked: IntSet
      keepGoing = true

    while keepGoing:
      keepGoing = false
      for row, rr in energy:
        for col, _ in rr:
          if energy[row][col] > 9 and coordToIdx(row, col) notin checked:
            keepGoing = true
            inc result
            checked.incl coordToIdx(row, col)

            incEnergy(row - 1, col - 1) # tl
            incEnergy(row - 1, col) # t
            incEnergy(row - 1, col + 1) # tr
            incEnergy(row, col - 1) # l
            incEnergy(row, col + 1) # r
            incEnergy(row + 1, col - 1) # bl
            incEnergy(row + 1, col) # b
            incEnergy(row + 1, col + 1) # br

  block resetFlashedToZero:
    for row in energy.mitems:
      row.applyIt(if it > 9: 0 else: it)

proc part1(filename: string, loops: int): int =
  var energy = loadHeightMap(filename)
  for _ in 0 ..< loops:
    result += runStep energy

proc part2(filename: string): int =
  var
    energy = loadHeightMap(filename)
    foundAnyNonZero = true

  while foundAnyNonZero:
    inc result
    runStep energy
    foundAnyNonZero = false
    for row in energy:
      foundAnyNonZero = foundAnyNonZero or row.anyIt(it > 0)

when isMainModule:
  doAssert part1("../data/day11_example.txt", 10) == 204
  doAssert part1("../data/day11_example.txt", 100) == 1656
  echo part1("../data/day11_input.txt", 100)

  doAssert part2("../data/day11_example.txt") == 195
  echo part2("../data/day11_input.txt")
