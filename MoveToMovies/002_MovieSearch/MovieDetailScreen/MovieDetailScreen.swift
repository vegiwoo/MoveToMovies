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

    @EnvironmentObject var vm: MovieSearchScreenViewModel
    @EnvironmentObject var appState: AppState
    
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
            
            
            
            
            NavPopButton(destination: PopDestination.previous, action: zeroingQuickLook) {
                CircleBackButtonLabel()
            }
        }.onAppear{
            print(vm.navigationStackCount())
        }
    }
    
    private func zeroingQuickLook () {
        appState.isQuickLink = false
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}
