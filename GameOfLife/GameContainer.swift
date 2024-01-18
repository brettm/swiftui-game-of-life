import SwiftUI

struct GameContainerView: View {
    
    @Environment(AppState.self) var appState: AppState
    @Environment(GameViewModel.self) var gameModel: GameViewModel
    
    @State var timer: Timer?
    
    var body: some View {
        @Bindable var appState = appState
        @Bindable var gameModel = gameModel
        VStack {
            
            TopBar()

            GeometryReader { proxy in
                GameView(viewModel: gameModel)
                    .background(.black)
                    .onTapGesture { location in
                        let index = getIndex(atLocation: location,
                                             gridSize: gameModel.gridSize,
                                             frameSize: proxy.size)
                        gameModel.insertPattern(atIndex: index)
                    }
                    .frame(maxHeight: .infinity)
            }
            .sheet(isPresented: $appState.showingSettings) {
                resetTimer()
            } content: {
                GameSettings()
            }
            .onAppear() {
                resetTimer()
            }
            
            GroupBox {
                Text(gameModel.selectedPattern.id + " \(gameModel.selectedPattern.size())")
                    .padding()
            } label: {
                PatternPicker(selectedPattern: $gameModel.selectedPattern)
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1/Double(appState.timeStepsPerSecond), repeats: true) {_ in
            gameModel.update(gameModel.timeStep + 1)
        }
    }
    
    private func getIndex(atLocation location: CGPoint, gridSize: (Int, Int), frameSize: CGSize) -> (Int, Int) {
        let ratio = (location.x / frameSize.width, location.y / frameSize.height)
        return (Int(floor(ratio.0 * CGFloat(gridSize.0))), Int(floor(ratio.1 * CGFloat(gridSize.1))))
    }
}

private struct TopBar: View {
    @Environment(AppState.self) var appState: AppState
    @Environment(GameViewModel.self) var gameModel: GameViewModel
    
    var body: some View {
        HStack {
            Button("Clear") { gameModel.resetCells() }
            Spacer()
            Text("Time Step: \(gameModel.timeStep)")
            Spacer()
            Button {
                appState.showingSettings.toggle()
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .padding()
    }
}
