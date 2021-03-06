//
//  MoveToMoviesApp.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI

@main
struct MoveToMoviesApp: App {
    var body: some Scene {
        
        let appState: AppState = .init()
        
        WindowGroup {
            MainScreen().environmentObject(appState)
        }
    }
}
