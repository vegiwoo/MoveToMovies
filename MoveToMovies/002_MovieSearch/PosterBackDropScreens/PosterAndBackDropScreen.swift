//
//  PosterAndBackDropScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 28.03.2021.
//

import SwiftUI

struct PosterAndBackDropScreen: View {
    
    @EnvironmentObject var vm: MovieSearchScreenViewModel
    
    private var posterData: Data?
    private var backdropData: Data?
    
    init(posterData: Data?, backdropData: Data?) {
        self.posterData = posterData
        self.backdropData = backdropData
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            if let posterData = posterData {
                                Image(uiImage: UIImage(data: posterData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 150, height: 150)
                            } else {
                                Circle()
                            }
                            Text("Poster")
                        }.onTapGesture {
                            vm.navigationPush(destination: AnyView(PosterOrBackDropScreen(data: posterData).environmentObject(vm)))
                        }
                        VStack {
                            if let backdropData = backdropData {
                                Image(uiImage: UIImage(data: backdropData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 150, height: 150)
                            } else {
                                Circle()
                            }
                            Text("Backdrop")
                        }
                        .onTapGesture {
                            vm.navigationPush(destination: AnyView(PosterOrBackDropScreen(data: backdropData).environmentObject(vm)))
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height / 5)
                    Spacer()
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
            
        }
        .frame(alignment: .center)
        .onAppear{
            
        }
    }
}

struct PosterAndBackDropScreen_Previews: PreviewProvider {
    
    static let movie = AppState.dataStoreService.getRendomMovieItem()
    static let posterData = movie?.poster?.blob
    static let backdropData = movie?.backdrop?.blob
    
    static var previews: some View {
        PosterAndBackDropScreen(posterData: posterData, backdropData: backdropData)
    }
}
