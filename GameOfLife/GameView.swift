//
//  GameView.swift
//  GameOfLife
//
//  Created by Brett Meader on 04/12/2023.
//

import SwiftUI

struct GameView: View {
    @Environment(AppState.self) var appState: AppState
    var viewModel: GameViewModel
    var body: some View {
        Canvas(opaque: false) { context, size in
            let cellSize = CGSize(width: size.width/Double(viewModel.gridSize.0),
                                  height: size.height/Double(viewModel.gridSize.1))
            _ = viewModel.cells.map { column in
                return column.filter{ $0.isActive }.map { cell in
                    context.fill(
                        Path(getRekt(index: cell.index, cellSize: cellSize)),
                        with: .color(appState.cellColor)
                    )
                }
            }
        }
        .background(appState.gameBackgroundColor)
    }
    func getRekt(index: (Int, Int), cellSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(index.0) * cellSize.width,
                      y: CGFloat(index.1) * cellSize.height,
                      width: cellSize.width, height: cellSize.height)
    }
}

//#Preview {
//    GameView()
//}
