import SwiftUI

struct GameContainerView: View {
    
    @Environment(AppState.self) var appState: AppState
    @State var timer: Timer?
    
    var body: some View {
        @Bindable var appState = appState
        GeometryReader { proxy in
            VStack(alignment: .center) {
                TopBar()
                Spacer()
                GameView()
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.width)
                    .padding()
                    .task { startTimer() }
                    .sheet(isPresented: $appState.showingSettings) {
                        resetTimer()
                    } content: {
                        GameSettings()
                    }
                Spacer()
                GroupBox {
                    PatternPicker(patterns: appState.allPatterns, selectedPattern: $appState.selectedPattern)
                } label: {
                    Text(appState.selectedPattern.id + " \(appState.selectedPattern.size())")
                        .padding()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1/Double(appState.timeStepsPerSecond), repeats: true) {timer in
           updateState()
        }
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    private func resetTimer() {
        stopTimer()
        startTimer()
    }
    
    private func updateState() {
        appState.gameState.update(appState.gameState.timeStep + 1)
    }
}

private struct TopBar: View {
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        HStack {
            Button("Clear") {
                appState.gameState.resetCells()
            }
            Spacer()
            Text("Time Step: \(appState.gameState.timeStep)")
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
