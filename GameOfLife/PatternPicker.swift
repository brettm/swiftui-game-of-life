import SwiftUI

struct PatternPicker: View {
    @Environment(AppState.self) var appState: AppState
    @Binding var selectedPattern: any Pattern
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 18.0) {
                ForEach(appState.patterns, id: \.id) { pattern in
                    GroupBox {
                        let model = GameViewModel(selectedPattern: pattern).insertPattern()
                        GameCanvas(viewModel: model)
                            .frame(width: 60, height: 60)
                            .onTapGesture {
                                selectedPattern = pattern
                            }
                    }
                }
            }
        }
    }
}
