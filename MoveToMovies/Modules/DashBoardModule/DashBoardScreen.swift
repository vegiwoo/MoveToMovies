//
//  DashBoardScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct DashBoardScreen: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: {
            appState.selectionTab = .popularMoviesScreen
            appState.randomMovie = appState.appViewModel.getRandomMovie() 
        }, label: {
            Text("Get random movie")
        }).onAppear{
            appState.randomMovie = nil
        }
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen()
    }
}
