//
//  PopularMoviesCell.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI




struct PopularMoviesCell: View, SizeClassAdjustable {
    
    @EnvironmentObject var appState: AppState
    let movie: Movie
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    @State private var currentWidth: CGFloat?
    @State private var currentHeight: CGFloat?

    @State var gernes: String?
    @State var movieYear: String?
    @State var poster: UIImage?
    
    var body: some View {
        GeometryReader{geometry in
            HStack(spacing: geometry.size.width / 50) {
                // Poster
                if let poster = poster {
                    Image(uiImage: poster)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .smallPosterFrame(geometrySize: geometry.size)
                        .cornerRadius(15)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke()
                        .foregroundColor(.gray)
                        .smallPosterFrame(geometrySize: geometry.size)
                }
                VStack(alignment: .leading, spacing: geometry.size.width / 65) {
                    // EmptyView
                    Text("")
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                    // Name
                    Text(movie.title ?? "")
                        .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.bold)
                        .lineLimit(2)
                    // Gernes
                    if let gernes = gernes {
                        Text(gernes)
                            .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.regular)
                            .lineLimit(2)
                    }
                    // Year
                    if let year = movieYear {
                        Text(year)
                            .font(Font.system(size: isPad ? 20 : isPadOrLandscapeMax ? 16 : 12)).fontWeight(.semibold)
                            .lineLimit(1)
                    }
                }.alignmentGuide(.leading, computeValue: { _ in 0 })
                
                ZStack {
                    Circle().stroke()
                    if let popularity = movie.voteAverage {
                        Text("\(popularity, specifier: "%.1f")").font(Font.system(size: 18))
                    }
                }.frame(width: isPad ? geometry.size.width / 12 : isPadOrLandscapeMax ? geometry.size.width / 10 : geometry.size.width / 8)
                .padding(.trailing)
                .foregroundColor(.secondary)
            }
            .onAppear{
                gernes = appState.appViewModel.getGernesString(for: movie)
                movieYear = appState.appViewModel.getYearForMovie(id: movie.id!)
                poster = appState.appViewModel.getPosterForMovie(id: movie.id!)
            }
        }
    }
}

struct PopularMoviesCell_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesCell(movie: Movie(title: "Some movie"))
    }
}
