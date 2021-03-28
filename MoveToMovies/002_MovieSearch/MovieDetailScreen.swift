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
        StretchyHeader(imageData: movie.poster!.blob!,
                       title: movie.title!,
                       content: AnyView(
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                            VStack {
                                ForEach(0..<50) {index in
                                    Text("Hello \(index)")
                                }
                            }
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
                        
                        
                        
                        
        ))
        
        
        
        
//        GeometryReader{geometry in
//            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
//                ScrollView {
//                    StretchyHeader(geometry: geometry, data: posterData, maxHeight: 200)
//                        .frame(maxHeight: 200)
//                    ForEach(0..<50) {index in
//                        Text("\(index)").font(Font.system(.title2))
//                    }
//                }
//                .edgesIgnoringSafeArea(.top)
//                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
//
//                HStack{
//                    Spacer()
//                    ZStack{
//                        Circle()
//                            .frame(width: 80, height: 80, alignment: .trailing)
//                            .foregroundColor(.white)
//                            .shadow(radius: 5)
//                            .onTapGesture {
//                                vm.navigationPop(destination: .previous)
//                            }
//                        Image(systemName: "arrow.backward").foregroundColor(.blue).font(.title)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.trailing, 32)
//                .padding(.bottom, 16)
//
//
//                Spacer()
//            }.padding()
//        }
//        .onAppear {
//            if let blob = movie.poster?.blob {
//                posterData = blob
//            }
//        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: AppState.dataStoreService.getRendomMovieItem() ?? MovieItem())
    }
}


