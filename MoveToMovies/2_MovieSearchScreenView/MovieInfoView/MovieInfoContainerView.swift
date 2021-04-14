//
//  MovieInfoContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieInfoContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>

    var body: some View {
        MovieInfoRenderView(
            selectedOMDBMovie: selectedOMDBMovie,
            searchOMDBMoviePoster: selectedOMDBMoviePoster,
            selectedTMDBMovie: selectedTMDBMovie
        )
    }
}

/// Binding variables
extension MovieInfoContainerView {
    private var selectedOMDBMovie: Binding<MovieOmdbapiObject?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie)
    }
    private var selectedOMDBMoviePoster: Binding<Data?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMoviePoster)
    }
    private var selectedTMDBMovie: Binding<MovieItem?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMovie) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.setSelectedTMDBMovieCovers(for: $0))
        }
    }
}

struct MovieInfoContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieInfoContainerView()
    }
}
