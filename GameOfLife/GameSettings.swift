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
        VStack(alignment: .trailing){
            Button("", systemImage: "xmark.circle") {
                appState.showingSettings = false
            }
            .padding()
            Form {
                Section(header: Text("Theme")) {
                    ColorPicker("Cell Color", selection: $appState.appColors.cellColor)
                    ColorPicker("Game Background", selection: $appState.appColors.gameBackgroundColor)
                }
                Section(header: Text("Game")) {
                    Stepper("\(appState.timeStepsPerSecond) tick per second", value: $appState.timeStepsPerSecond, in: 1...30)
                    Stepper("\(appState.gameSize.width) grid width", value: $appState.gameSize.width, in: 100...200)
                    Stepper("\(appState.gameSize.height) grid height", value: $appState.gameSize.height, in: 100...200)
                }
            }
        }
    }
}
