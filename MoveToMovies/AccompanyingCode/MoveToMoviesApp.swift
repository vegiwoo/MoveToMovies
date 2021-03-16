//
//  MoveToMoviesApp.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI

@main
struct MoveToMoviesApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        
        let appState: AppState = .init()
        
        WindowGroup {
            MainScreen()
                .environmentObject(appState)
                .environment(\.managedObjectContext, AppState.context)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App is active")
            case .inactive:
                print("App is inactive")
                appState.saveContext()
            case .background:
                print("App is in background")
                appState.saveContext()
            @unknown default:
                print("App is in ...?")
            }
        }
    }
}
