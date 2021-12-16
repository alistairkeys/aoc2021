import std/[sequtils, tables, sets, strutils]

# https://adventofcode.com/2021/day/12

proc part1(filename: string): int =

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

  var map: Table[char, set[char]]

  for l in filename.lines:
    var parts = l.split("-").mapIt(translate it)
    # Add A -> B and also B -> A.  The recursive function takes care of whether
    # backtracking, not the problem of this part of the code!
    map.mgetOrPut(parts[0], {}).incl parts[1]
    map.mgetOrPut(parts[1], {}).incl parts[0]

  type
    SearchNode = ref object
      pathTaken: string
      visited: set[char]

  var paths: seq[string]

  proc searchPath(node: SearchNode, thisNodeName: char) =
    if thisNodeName == '1': # End
      paths.add node.pathTaken & $thisNodeName
    elif thisNodeName notin node.visited or isUpperAscii thisNodeName:
      let cameFrom = if thisNodeName == '0': '0' else: node.pathTaken[^1]
      for connectingNode in map[thisNodeName] + {cameFrom}:
        searchPath(SearchNode(pathTaken: node.pathTaken & thisNodeName,
          visited: node.visited + {thisNodeName}), connectingNode)

  searchPath(SearchNode(pathTaken: ""), '0')

  result = paths.len

#proc part2(filename: string): int =
  #result = ?

when isMainModule:
  doAssert part1("../data/day12_example1.txt") == 10
  doAssert part1("../data/day12_example2.txt") == 19
  doAssert part1("../data/day12_example3.txt") == 226
  echo part1("../data/day12_input.txt")

  #doAssert part2("../data/day12_example1.txt") == 36
  #doAssert part2("../data/day12_example2.txt") == 103
  #doAssert part2("../data/day12_example3.txt") == 3509
  #echo part2("../data/day12_input.txt")
