//
//  GameTests.swift
//  TicTacToeTests
//
//  Created by Andres Vidal on 12/11/23.
//

import XCTest

final class GameTests: XCTestCase {

  var sut: Game!
  var boardSize: Int!
  var mark0 = Mark.o
  var markX = Mark.x
  let coordinates = [
    Coordinate(row: 0, column: 0),
    Coordinate(row: 0, column: 1),
    Coordinate(row: 0, column: 2),
    Coordinate(row: 1, column: 0),
    Coordinate(row: 1, column: 1),
    Coordinate(row: 1, column: 2),
    Coordinate(row: 2, column: 0),
    Coordinate(row: 2, column: 1),
    Coordinate(row: 2, column: 2),
  ]
  let indexes = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ]

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = Game()
    boardSize = sut.size
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testInit_default()  {
    XCTAssertEqual(sut!.board.count,9)
    XCTAssertEqual(sut!.board.filter{ $0 == Mark.none }.count, 9)
  }

  func testInit_invalidBoardSize() {
    do {
      _ = try Game(size: 2)
      XCTFail("Expected an error for invalid board size but got none.")
    } catch TicTacToeError.invalidBoardSize {
      // The expected error was thrown, so the test passes
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testInit_validBoardSize() {
    sut = try! Game(size: 9)
    XCTAssertEqual(sut!.board.count, 81)
  }

  func testValidCoordinate_Valid() {
    // Given
    let coordinate = Coordinate(row: 2, column: 2)
    // When
    // Then
    XCTAssertTrue(sut.isValid(coordinate))
  }

  func testValidCoordinate_Invalid() {
    // Given
    let coordinate = Coordinate(row: 3, column: 3)
    let anotherCoordinate = Coordinate(row: 6, column: -2)
    // When

    // Then
    XCTAssertFalse(sut.isValid(coordinate))
    XCTAssertFalse(sut.isValid(anotherCoordinate))
  }

  func testPutMark_invalid_throwsError() {
    // Given
    sut = Game() //
    let coordinate = Coordinate(row: 3, column: 3)
    let mark = Mark.o
    // When
    // Then
    XCTAssertThrowsError(try sut.put(mark, at: coordinate))
  }

  func testPutMark_valid_updatesBoard() {
    // Given
    let coordinate = Coordinate(row: 2, column: 2)
    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertNotNil(sut.getMark(at: coordinate))
    XCTAssertEqual(sut.getMark(at: coordinate),mark0)
  }

  func testPutMark_occupied_position() {
    // Given
    let coordinate = Coordinate(row: 2, column: 2)

    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertThrowsError(try sut.put(mark0, at: coordinate))
  }



  func testIsEmpty_returnsFalse() {
    // Given
    let coordinate = Coordinate(row: 2, column: 2)
    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertFalse(sut.isEmpty(coordinate))
  }

  func testIsEmpty_returnsTrue() {
    // Given
    // Clean Game
    var coordinate = Coordinate(row: 2, column: 2)

    // When
    try! sut.put(mark0, at: coordinate)
    coordinate = Coordinate(row: 1, column: 1)
    // Then
    XCTAssertTrue(sut.isEmpty(coordinate))
  }

  func testPutNextMark_returnsTrue() {
    // Given
    let firstCoordinate = Coordinate(row: 0, column: 0)
    let secondCoordinate = Coordinate(row: 0, column: 1)
    // When
    try! sut.putNextMark(at: firstCoordinate)
    try! sut.putNextMark(at: secondCoordinate)
    // Then
    XCTAssertEqual(sut.getMark(at: firstCoordinate),.x)
    XCTAssertEqual(sut.getMark(at: secondCoordinate),.o)

  }

  func testTranslateLinear_goodResponse() {
    // Given

    for index in 0..<9 {
      XCTAssertEqual(indexes[index],coordinates[index].translateLinear(size: boardSize))
    }

  }

  func testToogle_markNoneReturnsNone() {
    var mark = Mark.none
    mark.toogle()
    XCTAssertEqual(mark, Mark.none)
  }

  func testToogle_markReturnsOpposite() {
    var mark = Mark.x
    mark.toogle()
    XCTAssertEqual(mark, Mark.o)
    mark.toogle()
    XCTAssertEqual(mark, Mark.x)
  }

  func testOpposite_dontModifyOriginal() {
    let mark = Mark.x

    XCTAssertEqual(mark.opposite, Mark.o)
    XCTAssertEqual(mark, Mark.x)
  }

  func testOpposite_ofNoneIsNone() {
    let mark = Mark.none

    XCTAssertEqual(mark.opposite, Mark.none)
  }

  func testIsDiagonal_withDiagonalCoordinates(){
    let mainDiagonalCoordinate = Coordinate(row: 1, column: 1)
    let antiDiagonalCoordinate = Coordinate(row: 0, column: 2)
    let nonDiagonalCoordinate = Coordinate(row: 0, column: 1)

    XCTAssertTrue(sut.isDiagonal(mainDiagonalCoordinate))
    XCTAssertTrue(sut.isDiagonal(antiDiagonalCoordinate))
    XCTAssertFalse(sut.isDiagonal(nonDiagonalCoordinate))
  }

  func testGame_whenInitialized_isReadyState() {
    XCTAssertEqual(sut.status,Status.ready)
  }

  func testGame_whenPlayed_isInProgressState() {
    try! sut.putNextMark(at: Coordinate(row: 0, column: 0))
    XCTAssertEqual(sut.status,Status.inProgress)
  }

  func testValidateRow_afterPutNextMark_firstRow() {
    let moves = [
      Coordinate(row: 0, column: 0),
      Coordinate(row: 1, column: 0),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 0, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = sut.validateRow(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateRow_afterPutNextMark_MiddleRow() {
    let moves = [
      Coordinate(row: 1, column: 0),
      Coordinate(row: 0, column: 0),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = sut.validateRow(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateColum_afterPutNextMark() {
    let moves = [
      Coordinate(row: 0, column: 0),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 0),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 2, column: 0)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = sut.validateColumn(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateColum_afterPutNextMark_lastColum() {
    let moves = [
      Coordinate(row: 0, column: 2),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 2),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 2, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = sut.validateColumn(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateDiagonal_afterPutNextMark() {
    let moves = [
      Coordinate(row: 0, column: 0),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 0, column: 2),
      Coordinate(row: 2, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = try! sut.validateDiagonal(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateAntiDiagonal_afterPutNextMark() {
    let moves = [
      Coordinate(row: 0, column: 2),
      Coordinate(row: 1, column: 2),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 2, column: 2),
      Coordinate(row: 2, column: 0)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    let status = try! sut.validateAntiDiagonal(afterMove: sut.lastMove!, mark: sut.markByTurn.opposite)
    XCTAssertEqual(status,Status.winner(Mark.x))
  }

  func testValidateGame_FinishedInDraw() {
    let moves = [
      Coordinate(row: 0, column: 0),
      Coordinate(row: 1, column: 0),
      Coordinate(row: 2, column: 0),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 2, column: 1),
      Coordinate(row: 2, column: 2),
      Coordinate(row: 1, column: 2),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 0, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    XCTAssertEqual(sut.status,Status.draw)
  }

  func testPutNextMark_afterFinished_throwsError() {
    let moves = [
      Coordinate(row: 0, column: 0),
      Coordinate(row: 0, column: 1),
      Coordinate(row: 1, column: 1),
      Coordinate(row: 0, column: 2),
      Coordinate(row: 2, column: 2)
    ]
    for move in moves {
      try! sut.putNextMark(at: move)
    }
    XCTAssertThrowsError(try sut.putNextMark(at: Coordinate(row: 1, column: 0)))
  }

  func testMark_description(){
    XCTAssertEqual(String(describing: Mark.none),"-")
    XCTAssertEqual(String(describing: Mark.o),"O")
    XCTAssertEqual(String(describing: Mark.x),"X")
  }


  func testCoordinate_description(){
    XCTAssertEqual(String(describing: Coordinate(row:0,column: 1)),"(0,1)")
  }

  func testValidateAntidiagonal_throwsError_forNonDiagonalCoordinates(){
    XCTAssertThrowsError(try sut.validateAntiDiagonal(afterMove:  Coordinate(row:0,column: 1), mark: .x))
  }
}
