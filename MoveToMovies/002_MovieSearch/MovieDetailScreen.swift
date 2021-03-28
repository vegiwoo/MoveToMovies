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
    
    var movie: MovieItem
    @State var posterData: Data = UIImage(named: "dummyImage500x500")!.pngData()!

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            StretchyHeaderScreen(imageData: movie.poster!.blob!,
                                 title: movie.title!,
                                 content: AnyView( MovieView(movie: movie, actualColor: .orange)))
            HStack{
                Spacer()
                ZStack{
                    Circle()
                        .frame(width: 80, height: 80, alignment: .trailing)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .onTapGesture {
                            vm.navigationPop(destination: .previous)
                        }
                    Image(systemName: "arrow.backward").foregroundColor(.blue).font(.title)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, 32)
            .padding(.bottom, 16)
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}
