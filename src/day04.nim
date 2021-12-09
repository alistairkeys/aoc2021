import std/[strutils, streams, sequtils, intsets]

# https://adventofcode.com/2021/day/4

const
  squaresInRowOrCol = 5

type
  BingoNumber = 0..99

  Board = ref object
    rows, cols: array[5, set[BingoNumber]]

  BingoGame = ref object
    numbersToPick: seq[BingoNumber]
    boards: seq[Board]

proc newBoard(boardLines: openArray[seq[int]]): Board =

  assert boardLines.len == squaresInRowOrCol

  result = Board()

  for rowIdx, boardLine in boardLines:
    assert boardLine.len == squaresInRowOrCol
    for colIdx, bingoNum in boardLine:
      result.rows[rowIdx].incl bingoNum
      result.cols[colIdx].incl bingoNum

proc newBingoGame(filename: string): BingoGame =

  result = BingoGame()

  var f = newFileStream(filename)
  defer: f.close()

  result.numbersToPick = f.readLine.split(',').mapIt(BingoNumber(it.parseInt))

  while not f.atEnd:
    discard f.readLine
    var lines: array[squaresInRowOrCol, seq[int]]
    for idx in 0 ..< squaresInRowOrCol:
      lines[idx] = f.readLine.splitWhitespace.mapIt(it.parseInt)

    result.boards.add newBoard(lines)

proc winnerWinnerChickenDinner(board: Board): bool =
  board.rows.anyIt(it.card == 0) or board.cols.anyIt(it.card == 0)

proc claimNumber(board: Board, removeThis: BingoNumber): bool =
  ## Claims a number on the board. The return value indicates if this board wins
  for idx in 0 ..< squaresInRowOrCol:
    board.rows[idx].excl removeThis
    board.cols[idx].excl removeThis
  result = winnerWinnerChickenDinner board

proc calculateWinningScore(board: Board, mostRecentNum: BingoNumber): int =
  for row in board.rows:
    inc result, row.foldl(a + b, 0)
  result *= mostRecentNum

proc findFirstToWin(game: BingoGame): int =
  for bingoNum in game.numbersToPick:
    for board in game.boards:
      if board.claimNumber bingoNum:
        return board.calculateWinningScore bingoNum

proc findLastToWin(game: BingoGame): int =

  var mostRecentWin: tuple[board: Board, num: BingoNumber]
  var winners: IntSet

  for bingoNum in game.numbersToPick:
    for idx, board in game.boards:
      if idx notin winners and board.claimNumber bingoNum:
        mostRecentWin[0] = board
        mostRecentWin[1] = bingoNum
        winners.incl idx

  return mostRecentWin.board.calculateWinningScore(mostRecentWin.num)

proc part1(filename: string): int =
  var game = newBingoGame(filename)
  result = game.findFirstToWin

proc part2(filename: string): int =
  var game = newBingoGame(filename)
  result = game.findLastToWin

when isMainModule:
  doAssert part1("../data/day04_example.txt") == 4512
  echo part1("../data/day04_input.txt")

  doAssert part2("../data/day04_example.txt") == 1924
  echo part2("../data/day04_input.txt")
