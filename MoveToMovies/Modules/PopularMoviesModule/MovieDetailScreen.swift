//
//  MovieDetailScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 06.03.2021.
//

import SwiftUI
import TmdbAPI

struct MovieDetailScreen: View {
    
    var movie: MovieListResultObject
    
    var body: some View {
        NavigationView {
            Text(movie.title!).navigationBarTitle(Text(movie.title!))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: MovieListResultObject(title: "Some movie"))
    }
}
