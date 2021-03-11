//
//  DashBoardScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct DashBoardScreen: View {
    
    var body: some View {
        NavCoordinatorView() {
            DashBoardScreenContent()
        }
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen()
    }
}

struct DashBoardScreenContent: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: {
            appState.isQuickLink = true
        }, label: {
            Text("Get random movie")
        })
    }
}

struct DashBoardScreenContent_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreenContent()
    }
}
