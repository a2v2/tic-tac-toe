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
    Coordinate(x: 0, y: 0),
    Coordinate(x: 0, y: 1),
    Coordinate(x: 0, y: 2),
    Coordinate(x: 1, y: 0),
    Coordinate(x: 1, y: 1),
    Coordinate(x: 1, y: 2),
    Coordinate(x: 2, y: 0),
    Coordinate(x: 2, y: 1),
    Coordinate(x: 2, y: 2),
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
    let coordinate = Coordinate(x: 2, y: 2)
    // When
    // Then
    XCTAssertTrue(sut.isValid(coordinate))
  }

  func testValidCoordinate_Invalid() {
    // Given
    let coordinate = Coordinate(x: 3, y: 3)
    let anotherCoordinate = Coordinate(x: 6, y: -2)
    // When

    // Then
    XCTAssertFalse(sut.isValid(coordinate))
    XCTAssertFalse(sut.isValid(anotherCoordinate))
  }

  func testPutMark_invalid_throwsError() {
    // Given
    sut = Game() //
    let coordinate = Coordinate(x: 3, y: 3)
    let mark = Mark.o
    // When
    // Then
    XCTAssertThrowsError(try sut.put(mark, at: coordinate))
  }

  func testPutMark_valid_updatesBoard() {
    // Given
    let coordinate = Coordinate(x: 2, y: 2)
    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertNotNil(sut.getMark(at: coordinate))
    XCTAssertEqual(sut.getMark(at: coordinate),mark0)
  }

  func testPutMark_occupied_position() {
    // Given
    let coordinate = Coordinate(x: 2, y: 2)

    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertThrowsError(try sut.put(mark0, at: coordinate))
  }



  func testIsEmpty_returnsFalse() {
    // Given
    let coordinate = Coordinate(x: 2, y: 2)
    // When
    try! sut.put(mark0, at: coordinate)
    // Then
    XCTAssertFalse(sut.isEmpty(coordinate))
  }

  func testIsEmpty_returnsTrue() {
    // Given
    // Clean Game
    var coordinate = Coordinate(x: 2, y: 2)

    // When
    try! sut.put(mark0, at: coordinate)
    coordinate = Coordinate(x: 1, y: 1)
    // Then
    XCTAssertTrue(sut.isEmpty(coordinate))
  }

  func testPutNextMark_returnsTrue() {
    // Given
    var firstCoordinate = Coordinate(x: 0, y: 0)
    var secondCoordinate = Coordinate(x: 0, y: 1)
    // When
    try! sut.putNextMark(at: firstCoordinate)
    try! sut.putNextMark(at: secondCoordinate)
    // Then
    XCTAssertEqual(sut.getMark(at: firstCoordinate),.x)
    XCTAssertEqual(sut.getMark(at: secondCoordinate),.o)

  }

  func testTranslateLinear_goodResponse() {
    // Given

    var firstCoordinate = Coordinate(x: 0, y: 0)
    var middleCoordinate = Coordinate(x: 1, y: 1)
    var lastCoordinate = Coordinate(x: boardSize-1, y: boardSize-1)
    print(lastCoordinate)
    // When
    let result1 = firstCoordinate.translateLinear(size: sut.size)
    let result2 = middleCoordinate.translateLinear(size: sut.size)
    let result3 = lastCoordinate.translateLinear(size: sut.size)
    // Then
    XCTAssertEqual(result1,0)
    XCTAssertEqual(result2,4)
    XCTAssertEqual(result3,8)
  }
//
//  func testValidateLastMove_ifWins() {
//    // Given
//    // When
//    for coordinate in 0..<coordinates.count-1 {
//      sut.putNextMark(at: coordinate)
//    }
//    // Then
//    XCTAssertEqual(validateStatus(afterMove:coordinates[coordinates.count-1]),Status.winner)
//  }

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
    var mark = Mark.x

    XCTAssertEqual(mark.opposite, Mark.o)
    XCTAssertEqual(mark, Mark.x)
  }


}
