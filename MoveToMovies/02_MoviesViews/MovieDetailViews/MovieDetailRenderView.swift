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
    
    @EnvironmentObject var navigationStack: NavigationStack

    @Binding var selectedOMDBMovie: FoundItem?
    @Binding var selectedTMDBMovie: MovieItem?
    @Binding var isGotoPreviewsView: Bool

    @State var backButtonOpacity: Double = 1.0
    
    init(selectedOMDBMovie: Binding<FoundItem?>,
         selectedTMDBMovie: Binding<MovieItem?>,
         isGotoPreviewsView: Binding<Bool>) {
        self._selectedOMDBMovie = selectedOMDBMovie
        self._selectedTMDBMovie = selectedTMDBMovie
        self._isGotoPreviewsView = isGotoPreviewsView
    }

    var body: some View {
      
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {

            // Selected OMDB Movie
            if let selectedMovie = selectedOMDBMovie?.movie,
               let selectedPosterData = selectedOMDBMovie?.posterData {
                StretchyHeaderScreen(imageData: selectedPosterData, title: selectedMovie.title!, content: AnyView(
                                        MovieInfoContainerView()))
            } else if let movie = selectedTMDBMovie,
                      let posterData = movie.poster?.blob {
                // Selected TMDB Movie
                StretchyHeaderScreen(imageData: posterData, title: movie.title!, content: AnyView(MovieInfoContainerView()))
            }

            CircleBackButtonLabel()
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        isGotoPreviewsView = true
                    }
                }
        }
    }
}

struct MovieDetailRenderView_Previews: PreviewProvider {
    static var previews: some View {
        
        MovieDetailRenderView(selectedOMDBMovie: .constant(FoundItem(movie: MovieOmdbapiObject())),
                              selectedTMDBMovie: .constant(nil),
                              isGotoPreviewsView: .constant(false))
    }
}
