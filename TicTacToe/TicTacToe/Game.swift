//
//  Game.swift
//  TicTacToe
//
//  Created by Andres Vidal on 12/11/23.
//

import Foundation
import Combine

enum TicTacToeError: Error {
  case invalidBoardSize
  case invalidCoordinate
  case positionOccupied
  case coordinateNotDiagonal
  case gameAlreadyFinished
}

enum Mark: CustomStringConvertible {
  case none, x, o

  init(stringLiteral value: String) {
    guard value.count == 1 else {
      fatalError("Invalid string literal: \(value)")
    }
    switch value.first {
    case "-": 
      self = Mark.none
    case "X","x":
      self = Mark.x
    case "O", "o":
      self = Mark.o
    default:
      fatalError("Invalid string literal: \(value)")
    }
  }

  var description: String {
    switch self {
    case .none:
      return "-"
    case .x:
      return "X"
    case .o:
      return "O"
    }
  }

  mutating func toogle() {
    switch(self) {
    case .x:
      self = .o
    case .o:
      self = .x
    case .none:
      break
    }
  }

  var opposite: Mark {
    guard self != .none else { return .none }
    return self == Mark.x ? Mark.o : Mark.x
  }
}

enum Status: Equatable {
  case ready
  case inProgress
  case winner(Mark)
  case draw
}

struct Coordinate: CustomStringConvertible {
  let row: Int
  let column: Int

  public var description: String {
    return "(\(row),\(column))"
  }

  func translateLinear(size: Int) -> Int {
    size*row+column%size
  }
}

extension Coordinate: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    let components = value.split(separator: ",").compactMap { Int($0) }
    guard components.count == 2 else {
      fatalError("Invalid coordinate string literal: \(value)")
    }
    self.row = components[0]
    self.column = components[1]
  }
}

struct Game: CustomStringConvertible {

  var board: [Mark]!
  weak var delegate: GameDelegate?

  var description: String {

    let rows = stride(from: 0, to: board.count, by: size).map { Array(board[$0..<$0+size]) }

    let boardString = rows.map { row in
      row.map { String(describing: $0) }.joined(separator: " | ")
    }.joined(separator: "\n---------\n")

    return boardString
  }

  let size: Int!
  var markByTurn: Mark!
  var playCount = 0
  var status = Status.ready
  var lastMove: Coordinate?

  init() {
    try! self.init(size: 3)
  }

  init(size: Int = 3) throws {
    self.size = size
    guard size >= 3 else {
      throw TicTacToeError.invalidBoardSize
    }
    self.board = Array(repeating: .none, count: size*size)// Classical Game
    self.markByTurn = Mark.x
  }

  mutating func put(_ mark: Mark, at coordinate: Coordinate) throws {
    guard isValid(coordinate) else {
      throw TicTacToeError.invalidCoordinate
    }
    guard isEmpty(coordinate) else {
      throw TicTacToeError.positionOccupied
    }
    board[coordinate.translateLinear(size: size)] = mark
  }

  func getMark(at coordinate: Coordinate) -> Mark {
    return board[coordinate.translateLinear(size: size)]
  }

  func isValid(_ coordinate: Coordinate) -> Bool {
    0..<board.count ~= (coordinate.translateLinear(size: size))
  }

  func isEmpty(_ coordinate: Coordinate) -> Bool {
    return getMark(at: coordinate) == .none
  }

  func isDiagonal(_ coordinate: Coordinate) -> Bool {
    return coordinate.row == coordinate.column || coordinate.row + coordinate.column == size - 1
  }

  mutating func putNextMark(at coordinate: Coordinate) throws {
    guard status == .ready || status == .inProgress else { throw TicTacToeError.gameAlreadyFinished }
    try put(markByTurn, at: coordinate)
    playCount += 1
    delegate?.lastMark(markByTurn, at: coordinate)
    markByTurn.toogle()
    lastMove = coordinate
    updateStatus(afterMove: coordinate)
    delegate?.statusAfterLastMove(status)
    NotificationCenter.default.post(name: .gameDidMakeMove, object: self, userInfo:
                                      ["status": status]
    )
  }

  func validateRow(afterMove coordinate: Coordinate, mark: Mark) -> Status {
    var index = 0
    for column in 0..<size {
      index = size*coordinate.row+column%size
      if board[index] != mark || board[index] == .none {
        return Status.inProgress

      }
    }
    return Status.winner(mark)
  }

  func validateColumn(afterMove coordinate: Coordinate, mark: Mark) -> Status {
    var index = 0
    for row in 0..<size {
      index = size*row+coordinate.column%size
      if board[index] != mark || board[index] == .none {
        return Status.inProgress

      }
    }
    return Status.winner(mark)
  }

  func validateDiagonal(afterMove coordinate: Coordinate, mark: Mark) throws -> Status  {
    guard isDiagonal(coordinate) else {
      throw TicTacToeError.coordinateNotDiagonal
    }
    var index = 0
    for rowColumn in 0..<size {
      index = size*rowColumn+rowColumn%size
      if board[index] != mark || board[index] == .none {
        return Status.inProgress

      }
    }
    return Status.winner(mark)
  }

  func validateAntiDiagonal(afterMove coordinate: Coordinate, mark: Mark) throws -> Status  {
    guard isDiagonal(coordinate) else {
      throw TicTacToeError.coordinateNotDiagonal
    }
    var index = 0
    for rowColumn in 0..<size {
      index = size*rowColumn+(size-(rowColumn+1))%size
      if board[index] != mark || board[index] == .none {
        return Status.inProgress

      }
    }
    return Status.winner(mark)
  }

mutating func updateStatus(afterMove coordinate: Coordinate) {

    let lastMark = markByTurn.opposite
    status = validateRow(afterMove: coordinate, mark: lastMark)
    if status != .inProgress {
      return
    }
    status = validateColumn(afterMove: coordinate, mark: lastMark)
    if status != .inProgress {
      return
    }
    do {
      status = try validateDiagonal(afterMove: coordinate, mark: markByTurn.opposite)
      if status != .inProgress {
        return
      }
      status = try validateAntiDiagonal(afterMove: coordinate, mark: markByTurn.opposite)
      if status != .inProgress {
        return
      }
    } catch {

    }
    if playCount == board.count {
      status = .draw
    }
  }
}


protocol GameDelegate: AnyObject {
  func statusAfterLastMove(_ status: Status)
  func lastMark(_ mark: Mark, at coordinate: Coordinate)
}

// Notification name for the move status
extension Notification.Name {
    static let gameDidMakeMove = Notification.Name("GameDidMakeMoveNotification")
}

