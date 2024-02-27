import SwiftUI

struct PatternPicker: View {
    var patterns: [any Pattern]
    @Binding var selectedPattern: any Pattern
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 18.0) {
                ForEach(patterns, id: \.id) { pattern in
                    GroupBox {
                        var state = GameState(minGameSize: GameSize(width: pattern.size().0, height: pattern.size().1))
                            GameCanvas(gameState: state.insertPattern(pattern) )
                                .frame(width: 60, height: 60)
                                .onTapGesture { selectedPattern = pattern }
                    }
                }
            }
        }
    }
}
