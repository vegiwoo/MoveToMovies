//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import TmdbAPI

final class AppState: ObservableObject {
    @Published var selectionTab: TabbarView.Tab = .dashboardScreen
    @Published var appViewModel: MovieToMoviesViewModel = .init()
    @ObservedObject var popularMoviesViewModel: PopularMoviesViewModel = .init()
    @Published var isQuickLink = false {
        didSet {
            randomMovie = popularMoviesViewModel.getRandomElement()!
        }
    }
    @Published var randomMovie: MovieListResultObject = .init(title: "SomeMoview")
}

