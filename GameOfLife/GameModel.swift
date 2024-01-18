import Foundation

struct Cell {
    var index: (Int, Int)
    var isActive: Bool = false

    mutating func updateState(neighbours: [Cell?]) {
        let population = neighbours.compactMap{ $0 }.filter{ $0.isActive }.count
        let previouslyActive = self.isActive
        if previouslyActive { isActive = (2...3).contains(population) }
        else { self.isActive = population == 3 }
    }
}

@Observable
class GameViewModel {
    
    internal init(minGridSize: (Int, Int)? = nil, selectedPattern: any Pattern = Beehive())
    {
        self.selectedPattern = selectedPattern
        self.gridSize = minGridSize ?? selectedPattern.size()
        if gridSize < selectedPattern.size() {
            gridSize = selectedPattern.size()
        }
        self.cells = createCells()
    }
    
    // Resolution of the game
    var gridSize: (Int, Int) {
        didSet {
            resetCells()
        }
    }
    var selectedPattern: any Pattern
    
    private(set) var timeStep: UInt64 = 0
    private(set) var cells: [[Cell]] = [[]]
    
    public func resetCells() {
        cells = createCells()
    }
    
    public func update(_ timeStep: UInt64) {
        let cells = updateCells(timeStep)
        self.cells = cells
        self.timeStep = timeStep
    }
    
    @discardableResult
    public func insertPattern(pattern: (any Pattern)? = nil, atIndex index: (Int, Int) = (0, 0)) -> GameViewModel {
        let pattern = pattern ?? self.selectedPattern
        for (p_x, column) in pattern.shape.enumerated() {
            var x = index.1 + p_x
            if x < 0 { x = gridSize.1 + x }
            if x >= gridSize.1 { x = x - gridSize.1 }
            for (p_y, state) in column.enumerated() {
                var y = index.0 + p_y
                if y < 0 { y = gridSize.0 + y }
                if y >= gridSize.0 { y = y - gridSize.0 }
                var cell = cells[y][x]
                cell.isActive = state > 0
                cells[y][x] = cell
            }
        }
        return self
    }
    
    private func createCells() -> [[Cell]] {
        var newCells: [[Cell]] = []
        for x in 0..<gridSize.0 {
            var column: [Cell] = []
            for y in 0..<gridSize.1 {
                column.append(
                    Cell(index: (x, y))
                )
            }
            newCells.append(column)
        }
        return newCells
    }
    
    private func copyCell(atIndex idx: (Int, Int)) -> Cell? {
        var (x, y) = idx
        if x == -1 { x = gridSize.0 - 1 }
        if x == gridSize.0 { x = 0 }
        if y == -1 { y = gridSize.1 - 1 }
        if y == gridSize.1 { y = 0 }
        return cells[x][y]
    }
    
    private func updateCells(_ timeStep: UInt64) -> [[Cell]] {
        var newCells: [[Cell]] = cells
        for (x_pos, column) in cells.enumerated() {
            for (y_pos, cell) in column.enumerated() {
                var cell = cell
                cell.updateState(neighbours: [
                    copyCell(atIndex: (x_pos - 1, y_pos - 1)),
                    copyCell(atIndex: (x_pos - 0, y_pos - 1)),
                    copyCell(atIndex: (x_pos + 1, y_pos - 1)),
                    copyCell(atIndex: (x_pos - 1, y_pos - 0)),
                    copyCell(atIndex: (x_pos + 1, y_pos - 0)),
                    copyCell(atIndex: (x_pos - 1, y_pos + 1)),
                    copyCell(atIndex: (x_pos - 0, y_pos + 1)),
                    copyCell(atIndex: (x_pos + 1, y_pos + 1)),
                ])
                newCells[x_pos][y_pos] = cell
            }
        }
        return newCells
    }
}


