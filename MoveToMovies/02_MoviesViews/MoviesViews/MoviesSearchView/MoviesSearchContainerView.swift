//
//  MoviesSearchContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls

struct MoviesSearchContainerView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    
    var body: some View {
        MoviesSearchView(accentColor: .constant(.red),
                         searchQuery: searchQuery,
                         movieSearchStatus: movieSearchStatus,
                         foundMovies: foundMovies,
                         foundMoviesPosters: foundMoviesPosters,
                         needForFurtherLoad: needForFurtherLoad,
                         selectedOMDBMovie: selectedOMDBMovie,
                         progressLoad: progressLoad).padding(.horizontal)
    }
}

/// Bindings variables
extension MoviesSearchContainerView {

    private var movieSearchStatus: Binding<MovieSearchStatus> {
        appStore.binding(for: \.searchMovies.movieSearchStatus) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.changeStatusMovieSearch($0))
        }
    }
    private var searchQuery: Binding<String> {
        appStore.binding(for: \.searchMovies.searchQuery) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.loadSearchMovies(query: $0, page: 1))
        }
    }

    private var foundMovies: Binding<[MovieOmdbapiObject]> {
        appStore.binding(for: \.searchMovies.foundMovies)
    }
    private var foundMoviesPosters: Binding< [String: Data?]> {
        appStore.binding(for: \.searchMovies.foundMoviesPosters)
    }
    private var needForFurtherLoad: Binding<Bool> {
        appStore.binding(for: \.searchMovies.needForFurtherLoad) {_ in
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.loadSearchMovies(query: appStore.state.searchMovies.searchQuery, page: appStore.state.searchMovies.searchPage))
        }
    }
    private var progressLoad: Binding<Float> {
        appStore.binding(for: \.searchMovies.progressLoad)
    }
    private var selectedOMDBMovie: Binding<MovieOmdbapiObject?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.setSelectedOMDBMoviePoster(for: $0))
        }
    }
}

struct MoviesSearchContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesSearchContainerView()
    }
}

