//
//  Patterns.swift
//  GameOfLife
//
//  Created by Brett Meader on 06/12/2023.
//

import Foundation

class PatternFactory {
    static var allPatterns: [any Pattern] {[
        Beehive(),
        Toad(),
        Pulsar(),
        Pentadecathlon(),
        LightSpaceship(),
        MiddleSpaceship(),
        HeavyweightSpaceship(),
        SwitchEngine(),
        GosperGliderGun(),
        Period43GliderGun(),
        SnarkLoop(),
        EdgeRepairSpaceship()
    ]}
}

struct PatternLoader {
    static func loadShapeFromFile(filename: String, inBundle bundle: Bundle = .main) throws -> [[UInt8]] {
        let path = bundle.path(forResource: filename, ofType: nil)!
        let fileContent = try String(contentsOfFile: path)
        let lines = fileContent.components(separatedBy: .newlines).filter{ !$0.hasPrefix("!") }
        var shape: [[UInt8]] = [[]]
        for line in lines {
            let row = Self.shapeRow(fromLine: line)
            shape.append(row)
        }
        return Self.pad(shape)
    }
    
    private static func shapeRow(fromLine line: String) -> [UInt8] {
        var row: [UInt8] = []
        for char in line {
            if char == "." { row.append(0) }
            else if char == "O" { row.append(1) }
            else { fatalError("unexpected character: \(char) in pattern file")}
        }
        return row
    }
    
    /// Pads a shape with additional 0s to form an even matrix
    /// - Parameter shape: potentially unpadded matrix
    /// - Returns: matrix padded with trailing 0s
    private static func pad(_ shape: [[UInt8]]) -> [[UInt8]] {
        let maxWidth = shape.reduce(0) { result, row in
            return row.count > result ? row.count : result
        }
        return shape.map { row in
            var row = row
            row.append(contentsOf: Array(repeating: 0, count: maxWidth - row.count))
            return row
        }
    }
}

protocol Pattern: Identifiable, Equatable {
    var id: String { get }
    var shape: [[UInt8]] { get set }
    func size() -> (Int, Int)
}

extension Pattern {
    // w, h
    func size() -> (Int, Int) {
        return (shape.first?.count ?? 0, shape.count)
    }
}

struct Beehive: Pattern {
    var id = "Beehive"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 1, 1, 0],
            [1, 0, 0, 1],
            [0, 1, 1, 0]
        ]
    }
}

struct Toad: Pattern {
    var id = "Toad"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 0, 1, 0],
            [1, 0, 0, 1],
            [1, 0, 0, 1],
            [0, 1, 0, 0]
        ]
    }
}

struct Pulsar: Pattern {
    var id = "Pulsar"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0],
        ]
    }
}

struct Pentadecathlon: Pattern {
    var id = "Pentadecathlon"
    var shape: [[UInt8]]
    
    init() {
        self.shape = try! PatternLoader.loadShapeFromFile(filename: id)
    }
}

struct LightSpaceship: Pattern {
    var id = "Lightweight Spaceship"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 1, 0, 0, 1],
            [1, 0, 0, 0, 0],
            [1, 0, 0, 0, 1],
            [1, 1, 1, 1, 0],
        ]
    }
}

struct MiddleSpaceship: Pattern {
    var id = "Middleweight Spaceship"
    var shape: [[UInt8]]
    
    init() {
        self.shape = [
            [0, 0, 1, 0, 0, 0],
            [1, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 1],
            [0, 1, 1, 1, 1, 1],
        ]
    }
}

struct HeavyweightSpaceship: Pattern {
    var id = "Heavyweight Spaceship"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 0, 1, 1, 0, 0, 0],
            [1, 0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 1],
            [0, 1, 1, 1, 1, 1, 1],
        ]
    }
}

struct SwitchEngine: Pattern {
    var id = "Switch Engine"
    var shape: [[UInt8]]
    init() {
        self.shape = [
            [0, 1, 0, 1, 0, 0],
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 1, 0],
            [0, 0, 0, 1, 1, 1],
        ]
    }
}

struct GosperGliderGun: Pattern {
    var id = "Gosper Glider Gun"
    var shape: [[UInt8]]
    init() {
        self.shape = try! PatternLoader.loadShapeFromFile(filename: "GosperGliderGun")
    }
}

struct Period43GliderGun: Pattern {
    var id = "Period 43 Glider Gun"
    var shape: [[UInt8]]
    init() {
        self.shape = try! PatternLoader.loadShapeFromFile(filename: "Period43GliderGun")
    }
}

struct SnarkLoop: Pattern {
    var id = "Snark Loop"
    var shape: [[UInt8]]
    init() {
        self.shape = try! PatternLoader.loadShapeFromFile(filename: "SnarkLoop")
    }
}

struct EdgeRepairSpaceship: Pattern {
    var id = "Edge Repair Spaceship"
    var shape: [[UInt8]]
    init() {
        self.shape = try! PatternLoader.loadShapeFromFile(filename: "EdgeRepairSpaceship")
    }
}

