import std/[sequtils, tables, sets, strutils]

# https://adventofcode.com/2021/day/12

proc loadCaves(filename: string): Table[char, set[char]] =

  template translate(what: string): char =
    ## This function munches the node names into single characters so they can
    ## be put in a set.  It won't scale well as more node names get added for
    ## obvious reasons.
    case what
      of "start": '0'
      of "end": '1'
      of "ks": 's'
      of "mq": 'q'
      else: what[0]

  for l in filename.lines:
    var parts = l.split("-").mapIt(translate it)
    # Add A -> B and also B -> A.  The recursive function takes care of whether
    # backtracking makes sense, not the problem of this part of the code!
    result.mgetOrPut(parts[0], {}).incl parts[1]
    result.mgetOrPut(parts[1], {}).incl parts[0]

proc countPaths(filename: string, doTwoVisits: bool): int =

  type
    SearchNode = ref object
      pathTaken: string
      visited: set[char]
      visitTwice: char

  var map = loadCaves filename
  var paths: HashSet[string]

  proc searchPath(node: SearchNode, thisNodeName: char) =

    if thisNodeName == '1': # End
      paths.incl node.pathTaken & $thisNodeName

    elif thisNodeName notin node.visited or thisNodeName.isUpperAscii or
        thisNodeName == node.visitTwice:

      # cameFrom variable (hello INTERCAL) for backtracking
      let cameFrom = if thisNodeName == '0': '0' else: node.pathTaken[^1]

      # pretend we didn't visit a small cave if it's the visitTwice one
      var visited = node.visited
      if thisNodeName == node.visitTwice:
        node.visitTwice = '\0'
      else:
        visited.incl thisNodeName

      for connectingNode in map[thisNodeName] + {cameFrom}:
        searchPath(SearchNode(pathTaken: node.pathTaken & thisNodeName,
          visited: visited, visitTwice: node.visitTwice), connectingNode)

  if doTwoVisits:
    # This is sloppy as it will execute the search more than is necessary and
    # relies on the HashSet to take care of the dupes but it's not like the
    # logic takes a long time on my home PC.
    for ch in map.values.toSeq.foldl(a + b, set[char]({})):
      if ch.isLowerAscii:
        searchPath(SearchNode(pathTaken: "", visitTwice: ch), '0')
  else:
    searchPath(SearchNode(pathTaken: "", visitTwice: '\0'), '0')

  result = paths.len

proc part1(filename: string): int = countPaths(filename, false)
proc part2(filename: string): int = countPaths(filename, true)

when isMainModule:
  doAssert part1("../data/day12_example1.txt") == 10
  doAssert part1("../data/day12_example2.txt") == 19
  doAssert part1("../data/day12_example3.txt") == 226
  echo part1("../data/day12_input.txt")

  doAssert part2("../data/day12_example1.txt") == 36
  doAssert part2("../data/day12_example2.txt") == 103
  doAssert part2("../data/day12_example3.txt") == 3509
  echo part2("../data/day12_input.txt")
