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
    @EnvironmentObject var viewModel: MovieSearchScreenViewModel
    
    var networkService: NetworkService
    var dataStorageService: DataStorageService
    var actualColor: UIColor
    var title: String
    
    var body: some View {
        NavCoordinatorView {
            MovieSearchScreenContent(networkService: networkService, dataStorageService: dataStorageService, actualColor: actualColor, title: title)
                .environmentObject(appState)
                .environmentObject(viewModel)
        }
    }
}
