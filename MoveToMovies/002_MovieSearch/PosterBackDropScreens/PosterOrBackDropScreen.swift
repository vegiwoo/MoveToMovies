//
//  PosterOrBackDropScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 28.03.2021.
//

import SwiftUI

struct PosterOrBackDropScreen: View {
    
    private var data: Data?
    
    @EnvironmentObject var vm: MovieSearchScreenViewModel
    
    init(data: Data?) {
        self.data = data
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if let data = data {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    Text("No data to preview")
                        .frame(width: geometry.size.width, height: geometry.size.height)
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
            
        }.ignoresSafeArea()
        
    }
}

struct PosterOrBackDropScreen_Previews: PreviewProvider {
    
    static let movie = AppState.dataStoreService.getRendomMovieItem()
    static let posterData = movie?.poster?.blob
    
    
    static var previews: some View {
        PosterOrBackDropScreen(data: posterData)
    }
}
