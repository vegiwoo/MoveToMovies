//
//  MovieDetailContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieDetailContainerView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack

    @State var isGotoPreviewsView: Bool = false
    @Binding var isQuickTransition: Bool
    
    
    var body: some View {
        MovieDetailRenderView(selectedOMDBMovie: selectedOMDBMovie,
                              selectedTMDBMovie: selectedTMDBMovie,
                              isGotoPreviewsView: $isGotoPreviewsView)
            .onAppear {
                print("ℹ️ First nesting level of stack.")
            }
            .onChange(of: isGotoPreviewsView) { (value) in
                if value {
                    isQuickTransition = false
                    ns.pop() }
            }
    }
}

extension MovieDetailContainerView {
    private var selectedOMDBMovie: Binding<FoundItem?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie)
    }

    private var selectedOMDBMoviePosterData: Binding<Data?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMoviePoster)
    }

    private var selectedTMDBMovie: Binding<MovieItem?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMovie) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.setSelectedTMDBMovieCovers(for: $0))
        }
    }

}

struct MovieDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailContainerView(isQuickTransition: .constant(false))
    }
}
