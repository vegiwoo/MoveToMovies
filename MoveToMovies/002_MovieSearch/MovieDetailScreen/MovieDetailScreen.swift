//
//  MovieDetailScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 27.03.2021.
//

import SwiftUI
import UIControls
import Navigation

struct MovieDetailScreen: View {

    @Binding var selectSegment: Int
    @EnvironmentObject var vm: MovieSearchScreenViewModel
    
    var movie: MovieItem
    @State var posterData: Data = UIImage(named: "dummyImage500x500")!.pngData()!

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            StretchyHeaderScreen(imageData: movie.poster!.blob!,
                                 title: movie.title!,
                                 content: AnyView(
                                    MovieView(movie: movie, actualColor: .orange)
                                        .environmentObject(vm))
            )
            NavPopButton(destination: PopDestination.previous) {
                CircleBackButtonLabel()
            }
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(selectSegment: .constant(1), movie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}
