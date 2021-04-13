//
//  MovieDetailRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls
import Navigation

struct MovieDetailRenderView: View {
    
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel
   
    @Binding var selectedOMDBMovie: MovieOmdbapiObject?
    @Binding var selectedOMDBMoviePoster: Data?
    @Binding var selectedTMDBMovie: MovieItem?
    @Binding var isGotoPreviewsView: Bool
    
    init(selectedOMDBMovie: Binding<MovieOmdbapiObject?>, selectedOMDBMoviePoster: Binding<Data?>, selectedTMDBMovie: Binding<MovieItem?>, isGotoPreviewsView: Binding<Bool>) {
        self._selectedOMDBMovie = selectedOMDBMovie
        self._selectedOMDBMoviePoster = selectedOMDBMoviePoster
        self._selectedTMDBMovie = selectedTMDBMovie
        self._isGotoPreviewsView = isGotoPreviewsView
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            // Selected OMDB Movie
            if let selectedOMDBMovie = selectedOMDBMovie,
               let selectedOMDBMoviePoster = selectedOMDBMoviePoster {
                StretchyHeaderScreen(imageData: selectedOMDBMoviePoster, title: selectedOMDBMovie.title!, content: AnyView(
                                        MovieInfoContainerView()))
            } else if let movie = selectedTMDBMovie {
                // Selected TMDB Movie
                Text(movie.title!).padding()
            }

            CircleBackButtonLabel().onTapGesture {
                withAnimation(Animation.easeInOut(duration: 1.0)){
                    isGotoPreviewsView = true
                }
                
            }
        }
    }
}

struct MovieDetailRenderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailRenderView(selectedOMDBMovie: .constant(MovieOmdbapiObject()),
                              selectedOMDBMoviePoster: .constant(nil),
                              selectedTMDBMovie: .constant(nil),
                              isGotoPreviewsView: .constant(false))
    }
}
