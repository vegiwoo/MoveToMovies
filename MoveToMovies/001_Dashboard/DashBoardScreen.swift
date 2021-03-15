//
//  DashBoardScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct DashBoardScreen: View, BaseView {
    
    var actualColor: Color
    var title: String

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    @ObservedObject var vm: DashboardViewModel = .init()
    
    init(actualColor: Color, title: String) {
        self.actualColor = actualColor
        self.title = title
    }

    var body: some View {
        Button(action: {
            appState.isQuickLink = true
        }, label: {
            Text("Get random movie")
        }).onAppear {
            vm.setup(managedObjectContext)
        }
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text)
    }
}
