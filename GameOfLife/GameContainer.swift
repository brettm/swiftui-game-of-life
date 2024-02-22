import SwiftUI

struct GameContainerView: View {
    
    @Environment(AppState.self) var appState: AppState
    @Environment(GameViewModel.self) var gameModel: GameViewModel
    
    @State var timer: Timer?
    
    var body: some View {
        @Bindable var appState = appState
        @Bindable var gameModel = gameModel
        GeometryReader { proxy in
            VStack(alignment: .center) {
                TopBar()
                Spacer()
                GameView(viewModel: gameModel)
                    .frame(maxWidth: proxy.size.width,
                           maxHeight: proxy.size.width)
                    .padding()
                    .onAppear() {
                        resetTimer()
                    }
                    .sheet(isPresented: $appState.showingSettings) {
                        resetTimer()
                    } content: {
                        GameSettings()
                    }
                Spacer()
                GroupBox {
                    PatternPicker(selectedPattern: $gameModel.selectedPattern)
                } label: {
                    Text(gameModel.selectedPattern.id + " \(gameModel.selectedPattern.size())")
                        .padding()
                }
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
