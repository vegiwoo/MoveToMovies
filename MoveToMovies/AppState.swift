//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var selectionTab: TabbarView.Tab = .dashboardScreen
    @Published var appViewModel: MovieToMoviesViewModel = .init()
}

