//
//  PopularMoviesScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct PopularMoviesScreen: View, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    @ObservedObject var viewModel: PopularMoviesViewModel = .init()
    @EnvironmentObject var appState: AppState
    
    @State var isActive: (Bool, MovieListResultObject?) = (false, nil)
    
    var navigationLink: NavigationLink<EmptyView, MovieDetailScreen>? {
        guard isActive.0 == true,
              let movie = isActive.1 else {
            return nil
        }
        
        return NavigationLink(
            destination: MovieDetailScreen(movie: movie),
            isActive: $isActive.0,
            label: {
                EmptyView()
            })
    }

    var body: some View {
        NavigationView {
            GeometryReader{geometry in
                ZStack {
                    navigationLink
                    List(viewModel.movies){ movie in
                        PopularMoviesCell(movie: movie, isActive: $isActive)
                            .frame(width: geometry.size.width, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6 )
                    }.listStyle(InsetListStyle())
                }
            }
            .navigationBarTitle("Popular Movies")
        }
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}
