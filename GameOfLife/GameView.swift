//
//  GameView.swift
//  GameOfLife
//
//  Created by Brett Meader on 04/12/2023.
//

import SwiftUI

struct GameCanvas: View {
    @Environment(AppState.self) var appState: AppState
    var gameState: GameState?
    var gameSize: GameSize {
        return gameState?.gameSize ?? appState.gameSize
    }
    var cells: [[Cell]] {
        return gameState?.cells ?? appState.gameState.cells
    }
    var body: some View {
        EmptyView()
        Canvas(opaque: false) { context, size in
            let cellSize = CGSize(width: size.width/Double(gameSize.width), height: size.height/Double(gameSize.height))
            _ = cells.map { row in
                return row.filter{ $0.isActive }.map { cell in
                    context.fill(
                        Path( getRect(indexPath: cell.index, cellSize: cellSize) ),
                        with: .color(appState.appColors.cellColor)
                    )
                }
            }
        }
    }
        
    private func getRect(indexPath: IndexPath, cellSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(indexPath.row) * cellSize.width, y: CGFloat(indexPath.section) * cellSize.height, width: cellSize.width, height: cellSize.height)
    }
}

struct GameView: View {
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        GeometryReader { proxy in
            GameCanvas()
            .onTapGesture { location in
                let indexPath = getIndex(atLocation: location, gameSize: appState.gameSize, frameSize: proxy.size)
                appState.gameState = appState.gameState.insertPattern(appState.selectedPattern, atIndexPath: indexPath)
            }
            .background(appState.appColors.gameBackgroundColor)
        }
    }
    
    private func getIndex(atLocation location: CGPoint, gameSize: GameSize, frameSize: CGSize) -> IndexPath {
        let ratio = (location.x / frameSize.width, location.y / frameSize.height)
        return IndexPath(
            row: Int(floor(ratio.1 * CGFloat(gameSize.height))),
            section: Int(floor(ratio.0 * CGFloat(gameSize.width))))
    }
}

//#Preview {
//    GameView()
//}
