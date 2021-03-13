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
            appState.isQuickLink = true
        }, label: {
            Text("Get random movie")
        })
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen()
    }
}
