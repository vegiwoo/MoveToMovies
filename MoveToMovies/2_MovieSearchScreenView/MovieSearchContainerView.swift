//
//  MovieSearchContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation
import UIControls

extension MovieSearchContainerView {
    private var selectedIndexSegmentControl: Binding<Int> {
        appStore.binding(for: \.searchMovies.selectedIndexSegmentControl) {
            AppAction.searchMovies(action: SearchMoviesAction.assignIndexSegmentControl($0))
        }
    }
    private var movieSearchStatus: Binding<MovieSearchStatus> {
        appStore.binding(for: \.searchMovies.movieSearchStatus) {
            AppAction.searchMovies(action: SearchMoviesAction.changeStatusMovieSearch($0))
        }
    }
    
    private var searchQuery: Binding<String> {
        appStore.binding(for: \.searchMovies.searchQuery) {
            AppAction.searchMovies(action: SearchMoviesAction.loadSearchMovies(query: $0, page: 1))
        }
    }
    
    private var infoMessage: Binding<(symbol: String, message: String)> {
        appStore.binding(for: \.searchMovies.infoMessage)
    }
    
    private var foundMovies: Binding<[MovieOmdbapiObject]> {
        appStore.binding(for: \.searchMovies.foundMovies)
    }
    
    private var lastItemFound: Binding<Bool> {
        appStore.binding(for: \.searchMovies.needForFurtherLoad) {_ in 
            AppAction.searchMovies(action: SearchMoviesAction.loadSearchMovies(query: appStore.state.searchMovies.searchQuery, page: appStore.state.searchMovies.searchPage))
        }
    }
    
}

struct MovieSearchContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    
    var body: some View {
        NavCoordinatorView {
            MovieSearchRenderView(title: TabbarTab.movies.text,
                                  accentColor: TabbarTab.movies.actualColor,
                                  selectedIndexSegmentControl: selectedIndexSegmentControl,
                                  movieSearchStatus: movieSearchStatus,
                                  searchQuery: searchQuery,
                                  infoMessage: infoMessage,
                                  foundMovies: foundMovies, needForFurtherLoad: lastItemFound)
        }
    }
}

struct MovieSearchContainerView_Previews: PreviewProvider {
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MovieSearchContainerView().environmentObject(appStore)
    }
}
