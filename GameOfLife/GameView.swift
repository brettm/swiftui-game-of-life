//
//  GameView.swift
//  GameOfLife
//
//  Created by Brett Meader on 04/12/2023.
//

import SwiftUI

struct GameCanvas: View {
    @Environment(AppState.self) var appState: AppState
    var viewModel: GameViewModel
    var body: some View {
        Canvas(opaque: false) { context, size in
            let cellSize = CGSize(width: size.width/Double(viewModel.gridSize.0),
                                  height: size.height/Double(viewModel.gridSize.1))
            _ = viewModel.cells.map { column in
                return column.filter{ $0.isActive }.map { cell in
                    context.fill(
                        Path(getRect(index: cell.index, cellSize: cellSize)),
                        with: .color(appState.cellColor)
                    )
                }
            }
        }
    }
        
    func getRect(index: (Int, Int), cellSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(index.0) * cellSize.width,
                      y: CGFloat(index.1) * cellSize.height,
                      width: cellSize.width, height: cellSize.height)
    }
}

struct GameView: View {
    @Environment(AppState.self) var appState: AppState
    var viewModel: GameViewModel
    var body: some View {
        GeometryReader { proxy in
            GameCanvas(viewModel: viewModel)
            .onTapGesture { location in
                let index = getIndex(atLocation: location,
                                     gridSize: viewModel.gridSize,
                                     frameSize: proxy.size)
                viewModel.insertPattern(atIndex: index)
            }
            .background(appState.gameBackgroundColor)
        }
    }
    
    private func getIndex(atLocation location: CGPoint, gridSize: (Int, Int), frameSize: CGSize) -> (Int, Int) {
        let ratio = (location.x / frameSize.width, location.y / frameSize.height)
        return (Int(floor(ratio.0 * CGFloat(gridSize.0))), Int(floor(ratio.1 * CGFloat(gridSize.1))))
    }
}

//#Preview {
//    GameView()
//}
