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

    
    var body: some View {
        
        GeometryReader{geometry in
            VStack {
                Text("Popular Movies").font(Font.system(.largeTitle).bold()).padding(.bottom)
                List(appState.appViewModel.popularMovies){ movie in
                    PopularMoviesCell(movie: movie)
                        .frame(width: geometry.size.width - 36, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6)
                        .onTapGesture {
                            appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: movie))))
                        }
                }.listStyle(InsetListStyle())
            }
        }.onAppear{
            if appState.isQuickLink {
                appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: appState.randomMovie!))))
            }
        }
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}
