//
//  MainScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import UIControls

struct MainScreen: View {
    @EnvironmentObject var appState: AppState
       
    var body: some View {
<<<<<<< HEAD:MoveToMovies/Modules/MainModule/MainScreen.swift
        TabbarView(selectionScreen: $appState.selectionScreen)
=======
        TabbarView(selectionScreen: $appState.selectionScreen, vm: TabbarViewModel())
>>>>>>> dev:MoveToMovies/000_Main/MainScreen.swift
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
