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
   
    @Binding var selectedMovie: MovieOmdbapiObject?
    @Binding var selectedMoviePosterData: Data?
    @Binding var isGotoPreviewsView: Bool
    
    init(selectedMovie: Binding<MovieOmdbapiObject?>, foundMoviePosterData: Binding<Data?>, isGotoPreviewsView: Binding<Bool>) {
        self._selectedMovie = selectedMovie
        self._selectedMoviePosterData = foundMoviePosterData
        self._isGotoPreviewsView = isGotoPreviewsView
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                
            Text(selectedMovie?.title ?? "No title")

            Spacer()
            
            CircleBackButtonLabel().onTapGesture {
                selectedMovie = nil
                isGotoPreviewsView = true
            }
        }
    }
}

struct MovieDetailRenderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailRenderView(selectedMovie: .constant(MovieOmdbapiObject()),
                              foundMoviePosterData: .constant(nil),
                              isGotoPreviewsView: .constant(false))
    }
}
