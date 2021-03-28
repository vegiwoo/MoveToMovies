//
//  PosterAndBackDropScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 28.03.2021.
//

import SwiftUI
import UIControls
import Navigation


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

                                NavPushButton(destination: PosterOrBackDropScreen(data: posterData).environmentObject(vm)) {
                                    
                                    Image(uiImage: UIImage(data: posterData)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150)
                                }

                            } else {
                                Circle()
                            }
                            Text("Poster")

                        }
                        VStack {
                            if let backdropData = backdropData {
                                NavPushButton(destination: PosterOrBackDropScreen(data: backdropData).environmentObject(vm)) {
                                    
                                    Image(uiImage: UIImage(data: backdropData)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150)
                                }

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
                NavPopButton(destination: PopDestination.previous) {
                    CircleBackButtonLabel()
                }
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
