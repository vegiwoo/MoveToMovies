//
//  MovieSearchContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import CoreData
import Combine
import OmdbAPI
import Navigation
import UIControls

struct MovieSearchContainerView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack
    
    @State var isGotoDetailView: Bool = false
    
    var body: some View {
        ZStack {
            PushView(destination: MovieDetailContainerView(), isActive: $isGotoDetailView) {
                EmptyView()
            }
            MovieSearchRenderView(title: TabbarTab.movies.text,
                                  accentColor: TabbarTab.movies.actualColor,
                                  selectedIndexSegmentControl: selectedIndexSegmentControl,
                                  movieSearchStatus: movieSearchStatus,
                                  searchQuery: searchQuery,
                                  infoMessage: infoMessage,
                                  foundMovies: foundMovies,
                                  foundMoviesPosters: foundMoviesPosters,
                                  needForFurtherLoad: needForFurtherLoad,
                                  progressLoad: progressLoad,
                                  selectedOMDBMovie: selectedOMDBMovie,
                                  selectedTMDBMovie: selectedTMDBMovie
            )
            .environment(\.managedObjectContext, appStore.state.popularMovies.context!)
            .environmentObject(ns)
        }
        .onAppear {
            print("⬆️ MovieSearchContainerView onAppear")
        }.onChange(of: selectedOMDBMovie.wrappedValue) { (value) in
            if value != nil, isGotoDetailView == false {
                isGotoDetailView = true
            }
        }
    }
}

/// Bindings variables
extension MovieSearchContainerView {
    private var selectedIndexSegmentControl: Binding<Int> {
        appStore.binding(for: \.searchMovies.selectedIndexSegmentControl) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.assignIndexSegmentControl($0))
        }
    }
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
    private var infoMessage: Binding<(symbol: String, message: String)> {
        appStore.binding(for: \.searchMovies.infoMessage)
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
    private var selectedTMDBMovie: Binding<MovieItem?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMovie) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.setSelectedTMDBMovieCovers(for: $0))
        }
    }
}

struct MovieSearchContainerView_Previews: PreviewProvider {
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MovieSearchContainerView()
            .environmentObject(appStore)
    }
}
