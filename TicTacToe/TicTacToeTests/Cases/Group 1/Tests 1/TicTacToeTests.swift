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
}
