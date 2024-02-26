//
//  AppState.swift
//  GameOfLife
//
//  Created by Brett Meader on 23/02/2024.
//

import SwiftUI

struct AppColors: Codable, Equatable {
    
    internal init(){ }
    
    var cellColor: Color = .orange
    var gameBackgroundColor: Color = Color(.systemGray6)
    var selectedCellColor: Color = .yellow
    
    enum CodingKeys: CodingKey {
        case cellColor
        case gameBackgroundColor
        case selectedCellColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(cellColor), requiringSecureCoding: false)
        try container.encode(data, forKey: .cellColor)
        data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(gameBackgroundColor), requiringSecureCoding: false)
        try container.encode(data, forKey: .gameBackgroundColor)
        data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(selectedCellColor), requiringSecureCoding: false)
        try container.encode(data, forKey: .selectedCellColor)
    }
    
    func decode(codingKeys: CodingKeys, from decoder: Decoder) throws -> Color {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: codingKeys)
        guard let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [codingKeys], debugDescription: "Failed to decode"))
        }
        return Color(uiColor: uiColor)
    }
    
    init(from decoder: Decoder) throws {
        self.cellColor = try decode(codingKeys: .cellColor, from: decoder)
        self.gameBackgroundColor = try decode(codingKeys: .gameBackgroundColor, from: decoder)
        self.selectedCellColor = try decode(codingKeys: .selectedCellColor, from: decoder)
    }
}

@Observable
class AppState: Codable, Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.appColors == rhs.appColors &&
        lhs.timeStepsPerSecond == rhs.timeStepsPerSecond &&
        lhs.gameState.gameSize == rhs.gameState.gameSize
    }
    
    internal init(appColors: AppColors = AppColors(), timeStepsPerSecond: UInt8 = 30, gameSize: GameSize = GameSize(width: 150, height: 150)) {
        self.appColors = appColors
        self.timeStepsPerSecond = timeStepsPerSecond
        self.gameSize = gameSize
        self.gameState = GameState(minGameSize: gameSize)
    }
    
    var gameState: GameState
    let allPatterns: [any Pattern] = PatternFactory.allPatterns
    var selectedPattern: any Pattern = Beehive()
    var showingPatternPicker: Bool = false
    var showingSettings: Bool = false
    var appColors: AppColors = AppColors()
    var timeStepsPerSecond: UInt8
    var gameSize: GameSize {
        didSet {
            gameState.gameSize = gameSize
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case appColors
        case timeStepsPerSecond
        case gameSize
    }
    
    public var jsonData: Data? {
        get { return try! JSONEncoder().encode(self) }
        set {
            guard
                let data = newValue,
                let cached = try? JSONDecoder().decode(type(of: self), from: data)
            else { return }
            self.appColors = cached.appColors
            self.gameSize = cached.gameSize
            self.timeStepsPerSecond = cached.timeStepsPerSecond
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeStepsPerSecond, forKey: .timeStepsPerSecond)
        try container.encode(appColors, forKey: .appColors)
        try container.encode(gameSize, forKey: .gameSize)
    }
    
    required public init(from decoder: Decoder) throws {
        let decoded = try AppState.decode(from: decoder)
        self.appColors = decoded.appColors
        self.gameSize = decoded.gameSize
        self.gameState = GameState(minGameSize: decoded.gameSize)
        self.timeStepsPerSecond = decoded.timeStepsPerSecond
    }
    
    private static func decode(from decoder: Decoder) throws -> AppState {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeStepsPerSecond = try container.decode(UInt8.self, forKey: .timeStepsPerSecond)
        let appColors = try container.decode(AppColors.self, forKey: .appColors)
        let gameSize = try container.decode(GameSize.self, forKey: .gameSize)
        
        return AppState(appColors: appColors, timeStepsPerSecond: timeStepsPerSecond)
    }
}

