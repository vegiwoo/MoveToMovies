//
//  PopularMoviesCell.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct PopularMoviesCell: View, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    @State private var currentWidth: CGFloat?
    @State private var currentHeight: CGFloat?
    
    let movie: MovieListResultObject
    @Binding var isActive: (Bool, MovieListResultObject?)
    
    var body: some View {
        GeometryReader{geometry in
            HStack(spacing: geometry.size.width / 50) {
                RoundedRectangle(cornerRadius: 15)
                    .stroke()
                    .foregroundColor(.gray)
                    .frame(width: isPad ? geometry.size.width / 5 :  isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.width / 4 )
                VStack(alignment: .leading, spacing: geometry.size.width / 65) {
                    Text("")
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                    // Name
                    Text(movie.title ?? "")
                        .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.bold)
                        .lineLimit(2)
                    // Gerne
                    Text((movie.gerneIds != nil) ? String(movie.gerneIds!.first!) : "")
                        .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.regular)
                        .lineLimit(2)
                    // Year
                    Text(movie.releaseDate ?? "")
                        .font(Font.system(size: isPad ? 20 : isPadOrLandscapeMax ? 16 : 12)).fontWeight(.semibold)
                        .lineLimit(1)
                    Text("")
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }.alignmentGuide(.leading, computeValue: { _ in 0 })
                
                Circle()
                    .stroke()
                    .padding(.trailing)
                    .foregroundColor(.gray)
                    .frame(width: isPad ? geometry.size.width / 12 : isPadOrLandscapeMax ? geometry.size.width / 10 : geometry.size.width / 8)
            }.onTapGesture {
                isActive = (true, movie)
            }
            
        }
    }
}

struct PopularMoviesCell_Previews: PreviewProvider {
    static var previews: some View {
        
        PopularMoviesCell(movie: MovieListResultObject(), isActive: .constant((false, nil)))
    }
}
