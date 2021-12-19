import std/[sequtils, strutils, tables, heapqueue, algorithm, sugar]

# https://adventofcode.com/2021/day/15

type
  Point = tuple[x, y: int]

proc manhattan(a, b: Point): int {.inline.} =
  abs(b.x - a.x) + abs(b.y - a.y)

# Thank you Wikipedia!  The A* implementation is from pseudocode at:
# https://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode

proc reconstructPath(cameFrom: Table[Point, Point], current: Point): seq[Point] =
  result = @[current]
  var current = current
  while current in cameFrom:
    current = cameFrom[current]
    result.add current
  result.reverse

proc getNeighbours(where: Point): array[4, Point] {.inline.} =
  [(where.x - 1, where.y), (where.x + 1, where.y), (where.x, where.y-1), (
      where.x, where.y+1)]

func AStar(start, goal: Point, costs: seq[seq[int]], h: proc(
    where: Point): int): seq[Point] =

  # The heapqueue wants a 'less than' operator
  proc `<`(a, b: Point): bool {.used.} =
    manhattan(b, goal) < manhattan(a, goal)

  var
    openSet = [start].toHeapQueue
    cameFrom: Table[Point, Point]
    gScore, fScore: Table[Point, int]

  for y in 0 .. goal.y:
    for x in 0 .. goal.x:
      gScore[(x: x, y: y)] = int.high
      fScore[(x: x, y: y)] = int.high

  gScore[start] = 0
  fScore[start] = h(start)

  while openSet.len > 0:
    var current = openSet.pop
    if current.x == goal.x and current.y == goal.y:
      return reconstructPath(cameFrom, current)

    for neighbour in getNeighbours(current):

      if neighbour.x notin 0 .. goal.x or neighbour.y notin 0 .. goal.y:
        continue

      let tentative_gScore = gScore[current] + costs[neighbour.y][neighbour.x]
      if tentative_gScore < gScore[neighbour]:
        cameFrom[neighbour] = current
        gScore[neighbour] = tentative_gScore
        fScore[neighbour] = tentative_gScore + h(neighbour)
        if openSet.find(neighbour) == -1:
          openSet.push neighbour

  return @[(x: int.high, y: int.high)]

proc part1(filename: string): int =

  var costs: seq[seq[int]]
  for line in filename.lines:
    costs.add line.toSeq.mapIt(parseInt $it)

  let
    start = (x: 0, y: 0)
    goal = (x: costs[0].high, y: costs.high)
    path = AStar(start, goal, costs, (pt => manhattan(pt, goal)))

  result = path.mapIt(costs[it.y][it.x]).foldl(a + b, 0) - costs[0][0]


#proc part2(filename: string): int =
  #result = ??

when isMainModule:
  doAssert part1("../data/day15_example.txt") == 40
  echo part1("../data/day15_input.txt")

  #doAssert part2("../data/day15_example.txt") == ?
  #echo part2("../data/day15_input.txt")
