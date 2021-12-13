import std/[sequtils, tables, algorithm, math]

# https://adventofcode.com/2021/day/10

const expectedToken = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable

type
  ParsedLine = object
    stack: seq[char]
    badTokenScore: int

proc parseLine(line: string): ParsedLine =
  const badTokenScore = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  for token in line:
    if expectedToken.hasKey token:
      result.stack.add token
    elif token != expectedToken.getOrDefault(result.stack.pop, '\0'):
      result.badTokenScore = badTokenScore[token]
      break
  result.stack.reverse

proc part1(filename: string): int =
  sum filename.lines.toSeq.mapIt(it.parseLine.badTokenScore)

proc part2(filename: string): int =
  const incompleteTokenScores = {')': 1, ']': 2, '}': 3, '>': 4}.toTable
  let incompleteLineScores = filename.lines.toSeq.mapIt(it.parseLine).filterIt(
      it.badTokenScore == 0).mapIt(it.stack.foldl(a * 5 +
      incompleteTokenScores[expectedToken[b]], 0))
  incompleteLineScores.sorted[incompleteLineScores.len div 2]

when isMainModule:
  doAssert part1("../data/day10_example.txt") == 26397
  echo part1("../data/day10_input.txt")

  doAssert part2("../data/day10_example.txt") == 288957
  echo part2("../data/day10_input.txt")
