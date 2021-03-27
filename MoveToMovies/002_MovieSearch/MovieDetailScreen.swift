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
    @State var posterData: Data?
    
    var body: some View {
        GeometryReader{geometry in
            VStack(alignment: .leading, spacing: 16) {
                
                BackButtonLabel(text: "Back", color: Color.blue, width: geometry.size.width - 36)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(Font.system(.title2))
                    .padding([.leading, .top])
                    .onTapGesture{
                        vm.navigationPop(destination: .previous)
                    }
                
//                Group {
//                    if let data = posterData {
//                        Image(uiImage: UIImage(data: data)!)
//                            .resizable()
//                            .aspectRatio(1, contentMode: .fill)
//                    } else {
//                        Image(uiImage: UIImage(named: "dummyImage500x500")!)
//                            .resizable()
//                            .aspectRatio(1, contentMode: .fill)
//                    }
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height / 5, alignment: .center)
//                .clipShape(Rectangle())
//
                
                
                
                
                    
                
                Spacer()
            }
        }.onAppear {
           posterData = movie.poster?.blob
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}
