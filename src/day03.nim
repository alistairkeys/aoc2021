import std/[strutils, tables, sequtils, sugar]

# https://adventofcode.com/2021/day/3

proc part1(filename: string): int =

  let values = filename.lines.toSeq
  let maxLength = max(values.mapIt(it.len))
  var counts = newSeq[CountTable[char]](maxLength)

  for line in values:
    for idx, ch in line:
      counts[idx].inc ch

  var gammaRate, epsilonRate = newString(maxLength)
  for idx in 0 ..< maxLength:
    gammaRate[idx] = counts[idx].largest.key
    epsilonRate[idx] = if gammaRate[idx] == '1': '0' else: '1'

  result = fromBin[int](gammaRate) * fromBin[int](epsilonRate)

proc part2(filename: string): int =

  proc findMostOrLeast(values: seq[string], keepThisCharProc: proc (cnt0,
      cnt1: int): char): string =

    var values = values

    for idx in 0 ..< values.len:
      let
        cnt0 = values.countIt(it[idx] == '0')
        cnt1 = values.countIt(it[idx] == '1')
        keepThisChar = keepThisCharProc(cnt0, cnt1)

      values = values.filterIt(it[idx] == keepThisChar)
      if values.len == 1:
        return values[0]

  let
    values = filename.lines.toSeq
    oxygenGeneratorRating = findMostOrLeast(values, (cnt0, cnt1) => (if cnt0 >
        cnt1: '0' else: '1'))
    co2ScrubberRating = findMostOrLeast(values, (cnt0, cnt1) => (if cnt0 <=
        cnt1: '0' else: '1'))

  result = fromBin[int](oxygenGeneratorRating) * fromBin[int](co2ScrubberRating)

when isMainModule:
  doAssert part1("../data/day03_example.txt") == 198
  echo part1("../data/day03_input.txt")

  doAssert part2("../data/day03_example.txt") == 230
  echo part2("../data/day03_input.txt")
