//
//  DashBoardScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import Combine

struct DashBoardScreen: View, BaseView {
    
    var actualColor: Color
    var title: String
    
    @State var completionUpdatingData: Bool = false

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
            Group {
                if completionUpdatingData {
                    VStack{
                        ZStack {
                            Circle()
                                .foregroundColor(.gray)
                            Text("Get\nrandom movie")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                    }
                    .onTapGesture {
                        appState.isQuickLink = true
                        appState.selectTabIndex = 1
                    }
                } else {
                    ActivityIndicator(shouldAnimate: .constant(true), style: .large)
                }
            }.frame(width: 150, height: 150, alignment: .center)

            Spacer()
        }.onAppear {
            vm.setup(networkService: AppState.networkService, dataStorageService: AppState.dataStoreService)
            appState.isQuickLink = false
        }.onReceive(AppState.dataStoreService.dataStoragePublisher.requestPublisher) { (request) in
            switch request {
            case .startUpdatingData:
                break
            case .completionUpdatingData:
                completionUpdatingData = true
            case .getCoordinates(_):
                break
            case .getCovers(_):
                break
            }
        }
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text)
    }
}
