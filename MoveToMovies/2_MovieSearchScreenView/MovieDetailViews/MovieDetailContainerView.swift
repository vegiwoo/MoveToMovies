//
//  MovieDetailContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieDetailContainerView: View, IContaierView {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel

    @State var isGotoPreviewsView: Bool = false
    
    init() {}
    
    var body: some View {
        MovieDetailRenderView(selectedOMDBMovie: selectedMovie,
                              selectedOMDBMoviePoster: selectedMoviePosterData,
                              isGotoPreviewsView: $isGotoPreviewsView)
            .onAppear {
                isGotoPreviewsView = false
            }.onChange(of: isGotoPreviewsView) { (value) in
                if value {
                    navCoordinator.pop(to: .previous)
                }
            }
    }
}

extension MovieDetailContainerView {
    private var selectedMovie: Binding<MovieOmdbapiObject?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMovie) {
            AppAction.searchMovies(action: SearchMoviesAction.setSelectedMoviePoster(for: $0))
        }
    }

    private var selectedMoviePosterData: Binding<Data?> {
        appStore.binding(for: \.searchMovies.selectedOMDBMoviePoster)
    }
}
struct MovieDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailContainerView()
    }
}
