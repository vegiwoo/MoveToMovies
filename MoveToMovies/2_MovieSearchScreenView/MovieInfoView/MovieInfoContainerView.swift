//
//  MovieInfoContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieInfoContainerView: View, IContaierView {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel
    
    var body: some View {
        MovieInfoRenderView(
            selectedOMDBMovie: selectedOMDBMovie,
            searchOMDBMoviePoster: selectedOMDBMoviePoster,
            selectedTMDBMovie: .constant(nil)
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
}

struct MovieInfoContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieInfoContainerView()
    }
}
