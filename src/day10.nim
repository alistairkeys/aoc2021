import std/[sequtils, tables]

# https://adventofcode.com/2021/day/10

proc part1(filename: string): int =

  const badTokenScore = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  const expectedToken = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable
  func isOpening(ch: char): bool = expectedToken.hasKey ch
  func isClosing(ch: char): bool = ch in expectedToken.values.toSeq

  for l in filename.lines:
    var stack: seq[char]
    for token in l.toSeq:
      if isOpening token:
        stack.add token
      elif isClosing(token) and token != expectedToken.getOrDefault(stack.pop, '\0'):
        inc result, badTokenScore[token]
        break

#proc part2(filename: string): int =
  #result = ??

when isMainModule:
  doAssert part1("../data/day10_example.txt") == 26397
  echo part1("../data/day10_input.txt")

  #doAssert part2("../data/day10_example.txt") == ??
  #echo part2("../data/day10_input.txt")
