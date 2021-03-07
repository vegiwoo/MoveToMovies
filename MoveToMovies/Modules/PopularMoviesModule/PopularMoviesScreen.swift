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
    
    @State var selectedMovie: Movie?
    
    var body: some View {
        NavigationView {
            GeometryReader{geometry in
                List(appState.appViewModel.popularMovies){ movie in
                    PopularMoviesCell(movie: movie, selectedMovie: $selectedMovie)
                        .frame(width: geometry.size.width - 36, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6 )
                        .environmentObject(appState.appViewModel)
                }.listStyle(InsetListStyle())
            }
            .navigationBarTitle("Popular Movies")
            .navigate(using: $selectedMovie, destination: makeDestination)
            .onAppear{
                selectedMovie = appState.randomMovie != nil ? appState.randomMovie! : nil
            }
        }
    }
    
    @ViewBuilder
    private func makeDestination(for movie: Movie) -> some View {
        MovieDetailScreen(movie: movie, isMapPresented: false).environmentObject(appState)
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}
