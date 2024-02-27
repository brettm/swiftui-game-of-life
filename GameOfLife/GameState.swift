import Foundation

struct Cell {
    var index: IndexPath
    var isActive: Bool = false

    mutating func updateState(neighbours: [Cell?]) {
        let population = neighbours.compactMap{ $0 }.filter{ $0.isActive }.count
        let previouslyActive = self.isActive
        if previouslyActive { isActive = (2...3).contains(population) }
        else { self.isActive = population == 3 }
    }
}

struct GameSize: Codable, Equatable {
    var width: Int
    var height: Int
}

struct GameState: Sendable {
    
    internal init(minGameSize: GameSize = GameSize(width: 100, height: 100)) {
        self.gameSize = minGameSize
        self.cells = createCells()
    }
    
    // Resolution of the game
    public var gameSize: GameSize {
        didSet { reset() }
    }
    
    private(set) var timeStep: UInt64 = 0
    private(set) var cells: [[Cell]] = [[]]
    
    public mutating func reset() {
        cells = createCells()
        timeStep = 0
    }
    
    public mutating func update(_ timeStep: UInt64) {
        let cells = updateCells(timeStep)
        self.cells = cells
        self.timeStep = timeStep
    }
    
    public mutating func insertPattern(_ pattern: (any Pattern), atIndexPath indexPath: IndexPath = IndexPath(row: 0, section: 0)) -> GameState {
        if pattern.size().0 > gameSize.width || pattern.size().1 > gameSize.height {
            self.gameSize = GameSize(width: pattern.size().0, height: pattern.size().1)
        }
        for (p_y, row) in pattern.shape.enumerated() {
            var y = indexPath.row + p_y
            if y < 0 { y = gameSize.height + y }
            if y >= gameSize.height { y = y - gameSize.height }
            for (p_x, state) in row.enumerated() {
                var x = indexPath.section + p_x
                if x < 0 { x = gameSize.width + x }
                if x >= gameSize.width { x = x - gameSize.width }
                var cell = cells[y][x]
                cell.isActive = state > 0
                cells[y][x] = cell
            }
        }
        return self
    }
    
    private func createCells() -> [[Cell]] {
        var newCells: [[Cell]] = []
        for y in 0..<gameSize.height {
            var row: [Cell] = []
            for x in 0..<gameSize.width {
                row.append( Cell(index: IndexPath(row: x, section: y)) )
            }
            newCells.append(row)
        }
        return newCells
    }
    
    private func copyCell(atIndexPath idx: IndexPath) -> Cell? {
        var (y, x) = (idx.row, idx.section)
        if y == -1 { y = gameSize.height - 1 }
        if y == gameSize.height { y = 0 }
        if x == -1 { x = gameSize.width - 1 }
        if x == gameSize.width { x = 0 }
        return cells[y][x]
    }
    
    private func updateCells(_ timeStep: UInt64) -> [[Cell]] {
        var newCells: [[Cell]] = cells
        for (row_idx, row) in cells.enumerated() {
            for (col_idx, cell) in row.enumerated() {
                var cell = cell
                cell.updateState(neighbours: [
                    copyCell(atIndexPath: IndexPath(row: row_idx - 1, section: col_idx - 1)),
                    copyCell(atIndexPath: IndexPath(row: row_idx - 1, section: col_idx - 0)),
                    copyCell(atIndexPath: IndexPath(row: row_idx - 1, section: col_idx + 1)),
                    copyCell(atIndexPath: IndexPath(row: row_idx - 0, section: col_idx - 1)),
                    copyCell(atIndexPath: IndexPath(row: row_idx - 0, section: col_idx + 1)),
                    copyCell(atIndexPath: IndexPath(row: row_idx + 1, section: col_idx - 1)),
                    copyCell(atIndexPath: IndexPath(row: row_idx + 1, section: col_idx - 0)),
                    copyCell(atIndexPath: IndexPath(row: row_idx + 1, section: col_idx + 1))
                ])
                newCells[row_idx][col_idx] = cell
            }
        }
        return newCells
    }
}


