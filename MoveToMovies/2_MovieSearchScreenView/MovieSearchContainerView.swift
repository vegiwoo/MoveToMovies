//
//  MovieSearchContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import Navigation

extension MovieSearchContainerView {
    private var selectedIndexSegmentControl: Binding<Int> {
        appStore.binding(for: \.searchMovies.selectedIndexSegmentControl) {
            AppAction.searchMovies(action: SearchMoviesAction.assignIndexSegmentControl($0))
        }
    }
    private var searchQuery: Binding<String> {
        appStore.binding(for: \.searchMovies.searchQuery) {
            AppAction.searchMovies(action: SearchMoviesAction.loadSearchMovies(query: $0, page: 1))
        }
    }
    private var clearSearch: Binding<Bool> {
        appStore.binding(for: \.searchMovies.clearSearch) {
            AppAction.searchMovies(action: SearchMoviesAction.clearSearchResults($0))
        }
    }
    
    private var infoMessage: Binding<(symbol: String, message: String)> {
        appStore.binding(for: \.searchMovies.infoMessage)
    }
    
}


struct MovieSearchContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    
    var body: some View {
        NavCoordinatorView {
            MovieSearchRenderView(title: TabbarTab.movies.text,
                                  accentColor: TabbarTab.movies.actualColor,
                                  selectedIndexSegmentControl: selectedIndexSegmentControl,
                                  searchQuery: searchQuery,
                                  clearSearch: clearSearch,
                                  infoMessage: infoMessage)
        }
    }
}

struct MovieSearchContainerView_Previews: PreviewProvider {
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MovieSearchContainerView().environmentObject(appStore)
    }
}
