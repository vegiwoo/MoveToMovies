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

struct MovieSearchContainerView: View, IContaierView {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel
    
    @State var isGotoDetailedView: Bool = false
    
    var body: some View {
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
                              selectedMovie: selectedMovie
        )
        .onAppear {
            isGotoDetailedView = false
        }
        .onChange(of: appStore.state.searchMovies.selectedOMDBMovie) { (value) in
            if value != nil, isGotoDetailedView == false {
                isGotoDetailedView.toggle()
                navCoordinator.push(MovieDetailContainerView())
            } else {
                isGotoDetailedView = false
            }
        }
        
    }
}

/// Bindings variables
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
    
    private var foundMoviesPosters: Binding< [String: Data?]> {
        appStore.binding(for: \.searchMovies.foundMoviesPosters)
    }
    
    private var needForFurtherLoad: Binding<Bool> {
        appStore.binding(for: \.searchMovies.needForFurtherLoad) {_ in
            AppAction.searchMovies(action: SearchMoviesAction.loadSearchMovies(query: appStore.state.searchMovies.searchQuery, page: appStore.state.searchMovies.searchPage))
        }
    }
    
    private var progressLoad: Binding<Float> {
        appStore.binding(for: \.searchMovies.progressLoad)
    }
    
    private var selectedMovie: Binding<MovieOmdbapiObject?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie) {
            AppAction.searchMovies(action: SearchMoviesAction.setSelectedMoviePoster(for: $0))
        }
    }
    
}

struct MovieSearchContainerView_Previews: PreviewProvider {
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MovieSearchContainerView().environmentObject(appStore)
    }
}
