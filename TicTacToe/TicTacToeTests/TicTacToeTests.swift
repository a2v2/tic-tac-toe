//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Andres Vidal on 12/11/23.
//

import XCTest

final class TicTacToeTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
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
    measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testInit_default()  {
    let sut = Game()
    XCTAssertEqual(sut.board.count,9)
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
    do {
      let customGame = try Game(size: 9)
      XCTAssertEqual(customGame.board.count, 81)
    } catch {
      XCTFail("Unexpected error: \(error)")

    }
  }

//  func testIsEmpty_isntEmpty() {
//    // Given
//    let sut = Game() //
//    // When
//    let coordinate = Coordinate(x: 3, y: 3)
//    // Then
//    XCTAssertTrue(sut.isValid(coordinate))
//  }

}
