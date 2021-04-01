//
//  MainScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import UIControls
import OmdbAPI

struct MainScreen: View {
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    var body: some View {
        
        Button(action: {
            appStore.send(AppAction.searchMovies(action: SearchMoviesAction.loadSearchMovies(query: "Hello", page: 1)))
        }, label: {Text("Fetch!")})
        
        if appStore.state.searchMovies.foundFilms.count > 0 {
            ForEach(appStore.state.searchMovies.foundFilms) {movie in
                Text("\(movie.title ?? "")")
            }
        }
        //TabbarView(selectionScreen: $appState.selectionScreen, vm: TabbarViewModel())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
