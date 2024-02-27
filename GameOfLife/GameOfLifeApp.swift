//
//  GameOfLifeApp.swift
//  GameOfLife
//
//  Created by Brett Meader on 04/12/2023.
//

import SwiftUI

@main
struct GameOfLifeApp: App {
    @AppStorage("appData") private var data: Data?
    @State private var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            GameContainerView()
                .environment(appState)
                .task { if let data = data { appState.jsonData = data } }
                .onChange(of: appState.showingSettings) { _, newValue in
                    // Save data once user has dismissed settings
                    if newValue == false { data = appState.jsonData }
                }
        }
    }
}
