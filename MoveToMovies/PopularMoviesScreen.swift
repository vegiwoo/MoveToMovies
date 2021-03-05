//
//  PopularMoviesScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct PopularMoviesScreen: View {
    
    @ObservedObject var viewModel: PopularMoviesViewModel = .init()

    var body: some View {
        PopularMoviesCell(movie: MovieListResultObject())
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}
