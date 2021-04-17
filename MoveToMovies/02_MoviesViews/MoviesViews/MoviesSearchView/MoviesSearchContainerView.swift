//
//  MoviesSearchContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls
import Navigation

struct MoviesSearchContainerView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    
    @State var isGotoOMDBMovieDetailView: Bool = false
    
    var body: some View {
        ZStack {
            PushView(destination: MovieDetailContainerView(isQuickTransition: .constant(false)), isActive: $isGotoOMDBMovieDetailView) {
                EmptyView()
            }
            MoviesSearchRenderView(accentColor: .constant(.red),
                             searchQuery: searchQuery,
                             movieSearchStatus: movieSearchStatus,
                             foundItems: foundItems,
                             needForFurtherLoad: needForFurtherLoad,
                             selectedOMDBMovie: selectedOMDBMovie,
                             progressLoad: progressLoad)
                .onChange(of: appStore.state.searchMovies.selectedOMDBMovie, perform: { value in
                    if value != nil, isGotoOMDBMovieDetailView == false {
                        isGotoOMDBMovieDetailView.toggle()
                    } else {
                        isGotoOMDBMovieDetailView = false
                    }
                })
        }
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
    
    private var foundItems: Binding<[FoundItem]> {
        appStore.binding(for: \.searchMovies.foundItems)
    }

    private var needForFurtherLoad: Binding<Bool> {
        appStore.binding(for: \.searchMovies.needForFurtherLoad) {_ in
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.loadSearchMovies(query: appStore.state.searchMovies.searchQuery, page: appStore.state.searchMovies.searchPage))
        }
    }
    private var progressLoad: Binding<Double> {
        appStore.binding(for: \.searchMovies.progressLoad)
    }
    private var selectedOMDBMovie: Binding<FoundItem?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.setSelectedOMDB(item: $0))
        }
    }
}

struct MoviesSearchContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesSearchContainerView()
    }
}

