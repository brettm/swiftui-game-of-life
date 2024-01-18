//
//  GameSettings.swift
//  GameOfLife
//
//  Created by Brett Meader on 12/01/2024.
//
import SwiftUI

struct GameSettings: View {
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        @Bindable var appState = appState
        Form {
            Section(header: Text("Theme")) {
                ColorPicker("Cell Color", selection: $appState.cellColor)
                ColorPicker("Game Background", selection: $appState.gameBackgroundColor)
            }
            Section(header: Text("Game")) {
                Stepper("\(appState.timeStepsPerSecond) tick per second", value: $appState.timeStepsPerSecond, in: 1...30)
                HStack {
                    Stepper("\(appState.gridSize.0) grid width", value: $appState.gridSize.0, in: 100...200)
                    Stepper("\(appState.gridSize.1) grid height", value: $appState.gridSize.1, in: 100...200)
                }
            }
        }
    }
}
