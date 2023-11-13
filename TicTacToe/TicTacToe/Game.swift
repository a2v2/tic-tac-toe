//
//  Game.swift
//  TicTacToe
//
//  Created by Andres Vidal on 12/11/23.
//

import Foundation

enum TicTacToeError: Error {
  case invalidBoardSize
  case invalidCoordinate
  case positionOccupied
}

public enum Mark {
  case none, x, o

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

public enum Status {
  case winner(Mark)
  case draw
  case on
}

public struct Coordinate {
  let x: Int
  let y: Int

  func translateLinear(size: Int) -> Int {
    size*x+y%size
  }

  static func translateLinear(i: Int, j: Int, size: Int) -> Int {
    size*i+j%size
  }


}

public struct Game {

  var board: [Mark]! {
    didSet {
      if let coordinate = lastMove {
        validateStatus(afterMove: coordinate)
      }
    }
  }
  let size: Int!
  var markByTurn: Mark!
  var playCount = 0
  var status = Status.on
  var lastMove: Coordinate?



  // Convenience initializer to always create a game with board size 3
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
    return coordinate.x == coordinate.y || coordinate.x + coordinate.y == size - 1
  }

  mutating func putNextMark(at coordinate: Coordinate) throws {
    try put(markByTurn, at: coordinate)
    lastMove = coordinate
    markByTurn.toogle()
  }

  func validateStatus(afterMove coordinate: Coordinate) -> Status {
    // check file, column, diagonals
    // file, fix coordinate.x


    let lastMoveMark = markByTurn.opposite
    var mightWin = Status.winner(lastMoveMark)
    var index = 0
    // check row
    for i in 0..<size {
      index = size*coordinate.x+i%size
      if board[index] != lastMoveMark || board[index] == .none {
        mightWin = Status.on
        break
      }
    }
    // check colum
    for i in 0..<size {
      index = size*i+coordinate.y%size
      if board[index] != lastMoveMark || board[index] == .none {
        mightWin = Status.on
        break
      }
    }
//    if isDiagonal(coordinate) {
//      for i in 0..<size {
//        index = size/i+coordinate.y%size
//        if board[index] != lastMoveMark || board[index] == .none {
//          mightWin = Status.on
//          break
//        }
//      }
//    }
    return mightWin
  }

//  func validateGameEnds(after coordinate: Coordinate) -> Result {
//    let lines = [(0,1),(1,0),(1,1)]
//    let mark = getMark(at: coordinate)
//    
//    }
//
//
//  }
}
