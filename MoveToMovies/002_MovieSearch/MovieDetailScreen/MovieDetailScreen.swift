//
//  MovieDetailScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 27.03.2021.
//

import SwiftUI
import UIControls
import Navigation
import OmdbAPI

struct MovieDetailScreen: View {

    @EnvironmentObject var vm: MovieSearchScreenViewModel
    @EnvironmentObject var appState: AppState
    
    var movie: MovieItem?
    var searchMovie: (MovieOmdbapiObject, Data?)?
    
    @State var posterData: Data = UIImage(named: "dummyImage500x500")!.pngData()!

    init(popularMovie: MovieItem? = nil, searchMovie: (MovieOmdbapiObject, Data?)? = nil) {
        if let popularMovie = popularMovie {
            self.movie = popularMovie
        }
        if let searchMovie = searchMovie {
            self.searchMovie = searchMovie
        }
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            if let movie = movie {
                StretchyHeaderScreen(imageData: movie.poster!.blob!,
                                     title: movie.title!,
                                     content: AnyView(
                                        MovieView(popularMovie: movie, actualColor: .orange)
                                            .environmentObject(vm))
                )
                NavPopButton(destination: PopDestination.previous, action: zeroingQuickLook) {
                    CircleBackButtonLabel()
                }
            } else if let searchMovie = searchMovie {
                StretchyHeaderScreen(imageData: searchMovie.1 ?? posterData,
                                     title: searchMovie.0.title!,
                                     content: AnyView(
                                        MovieView(searchMovie: searchMovie, actualColor: .orange)
                                            .environmentObject(vm))
                )
                NavPopButton(destination: PopDestination.previous, action: zeroingQuickLook) {
                    CircleBackButtonLabel()
                }
            }
        }
    }
    
    private func zeroingQuickLook () {
        appState.isQuickLink = false
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(popularMovie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}
