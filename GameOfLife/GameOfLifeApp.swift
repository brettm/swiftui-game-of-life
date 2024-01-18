//
//  GameOfLifeApp.swift
//  GameOfLife
//
//  Created by Brett Meader on 04/12/2023.
//

import SwiftUI

@Observable
class AppState {
    
    let patterns: [any Pattern] = PatternFactory.allPatterns
    var showingPatternPicker: Bool = false
    var showingSettings: Bool = false
    
    var cellColor: Color = .orange
    var gameBackgroundColor: Color = .black
    var selectedCellColor: Color = .yellow
    var timeStepsPerSecond: UInt8 = 30
    var gridSize: (Int, Int) = (150, 150)
    
    enum CodingKeys: String, CodingKey {
        case cellColor
        case gameBackgroundColor
        case selectedCellColor
        case timeStepsPerSecond
        case gridSize
    }
    
    
//    public var jsonData: Data? {
//        get { 
//            return try? JSONEncoder().encode(self)
//        }
//        set {
//            guard
//                let data = newValue,
//                let cached = try? JSONDecoder().decode(type(of: self), from: data)
//            else { return }
////            self.items = cached.items.sorted(by: { $0.id < $1.id })
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        let colorData = try NSKeyedArchiver.archivedData(withRootObject: cellColor, requiringSecureCoding: false)
//        try container.encode(cellColor, forKey: .cellColor)
//    }
//    
//    required public init(from decoder: Decoder) throws {
//        let decoded = try AppState.decode(from: decoder)
//        self.items = decoded.items
//    }
//    
//    private static func decode(from decoder: Decoder) throws -> TransitionViewModel {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let selectedImage = try container.decodeIfPresent(String.self, forKey: .selectedSystemImage)
//       
//        let data: [Int: Transition] = AppState.transitionItems.reduce(into: [:]) { partialResult, transition in
//            var transition = transition
//            if let selectedImage, transition.type == .none {
//                transition.systemSymbolName = selectedImage
//            }
//            partialResult[transition.id] = transition
//        }
//        return TransitionViewModel(items: Array(data.values))
//    }
}

@main
struct GameOfLifeApp: App {
//    @AppStorage("appData") private var data: Data?
    @State var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            GameContainerView()
                .environment(appState)
                .environment(GameViewModel(minGridSize: appState.gridSize))
        }
    }
}
