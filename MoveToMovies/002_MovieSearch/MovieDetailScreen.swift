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
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                ScrollView {
                    ForEach(0..<99) {index in
                        Text("Some indexes in indexes in indexes\(index) \(index) \(index)")
                    }
                    
                }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
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
 
                
                Spacer()
            }.padding()
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
