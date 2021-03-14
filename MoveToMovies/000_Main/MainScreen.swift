//
//  MainScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var appState: AppState
       
    var body: some View {
        TabbarView(selectionScreen: $appState.selectionScreen, vm: TabbarViewModel())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
