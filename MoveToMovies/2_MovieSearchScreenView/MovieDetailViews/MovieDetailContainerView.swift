//
//  MovieDetailContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieDetailContainerView: View /*, IContaierView*/ {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel

    @State var isGotoPreviewsView: Bool = false
    
    init() {}
    
    var body: some View {

        MovieDetailRenderView(selectedOMDBMovie: selectedOMDBMovie,
                              selectedOMDBMoviePoster: selectedOMDBMoviePosterData,
                              selectedTMDBMovie: selectedTMDBMovie,
                              isGotoPreviewsView: $isGotoPreviewsView)
            .valueChanged(value: isGotoPreviewsView, onChange: { (value) in
                if value { navCoordinator.pop(to: .previous) }
            })
    }
}

extension MovieDetailContainerView {
    private var selectedOMDBMovie: Binding<MovieOmdbapiObject?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie) {
            AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.setSelectedOMDBMoviePoster(for: $0))
        }
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
        MovieDetailContainerView()
    }
}
