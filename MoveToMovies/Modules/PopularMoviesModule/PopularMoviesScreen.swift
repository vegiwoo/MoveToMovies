//
//  PopularMoviesScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct PopularMoviesScreen: View {

    var body: some View {
        NavCoordinatorView() {
            PopularMoviesScreenContent()
        }
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen()
    }
}

struct PopularMoviesScreenContent: View, SizeClassAdjustable {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: NavCoordinatorViewModel
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }

    var body: some View {
        GeometryReader{geometry in
            VStack {
                Text("Popular Movies").font(Font.system(.largeTitle).bold()).padding(.bottom)
                ScrollView {
                    ForEach(appState.appViewModel.popularMovies) {movie in
                        NavPushButton(destination: MovieDetailScreen(movie: movie)) {
                            PopularMoviesCell(movie: movie)
                        }.frame(width: geometry.size.width - 36, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6)
                        
                    }
                }.padding()
                
                
                
                //List(appState.appViewModel.popularMovies){ movie in
                   
                    
                    
             
//                            appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: movie))))
                        
               // }
            }
        }.onAppear{
            if appState.isQuickLink {
//                appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: appState.randomMovie!))))
            }
        }
    }
}

struct PopularMoviesScreenContent_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreenContent()
    }
}
