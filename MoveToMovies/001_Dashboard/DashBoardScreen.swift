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
        VStack {
            Spacer()
            VStack{
                ZStack {
                    Circle().foregroundColor(.gray)
                    Text("Get\nrandom movie").multilineTextAlignment(.center).foregroundColor(.white)
                }
            }.frame(width: 150, height: 150, alignment: .center)
            .onTapGesture {
                appState.isQuickLink = true
                appState.selectTabIndex = 1
            }
            Spacer()
        }.onAppear {
            vm.setup(networkService: AppState.networkService, dataStorageService: AppState.dataStoreService)
            appState.isQuickLink = false
        }
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text)
    }
}
