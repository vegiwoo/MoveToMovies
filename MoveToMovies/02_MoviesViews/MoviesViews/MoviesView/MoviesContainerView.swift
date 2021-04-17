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

struct MoviesContainerView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack
    
    @State var isGotoOMDBMovieDetailView: Bool = false
    @State var isGotoTMDBMovieDetailView: Bool = false
    
    var body: some View {
        ZStack {
            PushView(destination: MovieDetailContainerView(isQuickTransition: gotoDetailedView), isActive: $isGotoTMDBMovieDetailView) {
                EmptyView()
            }
            if gotoDetailedView.wrappedValue {
                EmptyView()
            } else {
                MoviesRenderView(title: TabbarTab.movies.text,
                                      accentColor: TabbarTab.movies.actualColor,
                                      selectedIndexSegmentControl: selectedIndexSegmentControl,
                                      selectedTMDBMovie: selectedTMDBMovie,
                                      gotoDetailedView: gotoDetailedView
                )
                .environment(\.managedObjectContext, appStore.state.popularMovies.context!)
                .environmentObject(ns)
            }
        }.onAppear {
            if gotoDetailedView.wrappedValue {
                guard selectedTMDBMovie.wrappedValue != nil else {
                    fatalError()
                }
                isGotoTMDBMovieDetailView = true
            }
        }
        .onChange(of: selectedTMDBMovie.wrappedValue, perform: { value in
            if value != nil, isGotoTMDBMovieDetailView == false {
                isGotoTMDBMovieDetailView.toggle()
            } else {
                isGotoTMDBMovieDetailView = false
            }
        })
    }
}

/// Bindings variables
extension MoviesContainerView {
    private var selectedIndexSegmentControl: Binding<Int> {
        appStore.binding(for: \.searchMovies.selectedIndexSegmentControl) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.assignIndexSegmentControl($0))
        }
    }

    private var selectedTMDBMovie: Binding<MovieItem?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMovie) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.setSelectedTMDBMovieCovers(for: $0))
        }
    }
    private var gotoDetailedView: Binding<Bool> {
        appStore.binding(for: \.popularMovies.quickTransition) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.isQuickTransition($0))
        }
    }
}

struct MovieSearchContainerView_Previews: PreviewProvider {
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MoviesContainerView()
            .environmentObject(appStore)
    }
}
