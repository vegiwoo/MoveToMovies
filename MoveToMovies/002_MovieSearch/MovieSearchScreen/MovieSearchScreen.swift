//
//  SwiftUIView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI
import UIControls
import Navigation

struct MovieSearchScreen: View {
    
    @EnvironmentObject var appState: AppState
    
    var networkService: NetworkService
    var dataStorageService: DataStorageService
    var actualColor: Color
    var title: String
    
    var body: some View {
        NavCoordinatorView {
            MovieSearchScreenContent(networkService: networkService, dataStorageService: dataStorageService, actualColor: actualColor, title: title).environmentObject(appState)
        }
    }
}
