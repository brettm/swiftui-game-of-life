//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Brett Meader on 26/02/2024.
//

import XCTest

@testable import GameOfLife

final class GameOfLifeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameState() {
        var state = GameState(minGameSize: GameSize(width: 1, height: 2))
        XCTAssert(state.cells.count == 2)
        XCTAssert(state.cells.first!.count == 1)
        let beehive = Beehive()
        let beehiveSize = beehive.size()
        XCTAssert(beehiveSize.0 == 4)
        XCTAssert(beehiveSize.1 == 3)
        state=state.insertPattern(Beehive())
        XCTAssert(state.cells.count == 3)
        XCTAssert(state.cells.first!.count == 4)
        let expected = [
            [0, 1, 1, 0],
            [1, 0, 0, 1],
            [0, 1, 1, 0]
        ]
        for (row_idx, cells) in state.cells.enumerated() {
            for (col_idx, cell) in cells.enumerated() {
                XCTAssert((expected[row_idx][col_idx] == 1) == cell.isActive)
            }
        }
    }
}
