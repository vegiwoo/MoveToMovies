//
//  PopularMoviesScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct PopularMoviesScreen: View, SizeClassAdjustable {
    
    @EnvironmentObject var appState: AppState
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var navigationLink: NavigationLink<EmptyView, MovieDetailScreen>? {
        return NavigationLink(destination: MovieDetailScreen(movie: appState.randomMovie, isMapPresented: false), isActive: $appState.isQuickLink) { EmptyView() }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader{geometry in
                List(appState.popularMoviesViewModel.movies){ movie in
                    PopularMoviesCell(movie: movie)
                        .frame(width: geometry.size.width, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6 )
                        .environmentObject(appState.popularMoviesViewModel)
                }.listStyle(InsetListStyle())
            }
            .navigationBarTitle("Popular Movies")
            .overlay(navigationLink?.environmentObject(appState.popularMoviesViewModel).hidden())
        }
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}
