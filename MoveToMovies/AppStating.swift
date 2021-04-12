//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import CoreData
import Combine
import TmdbAPI

final class AppStating: ObservableObject {
    
    @StateObject var movieSearchVM: MovieSearchScreenViewModel = .init(AppStating.dataStoreService.context, dataStorageService: AppStating.dataStoreService)
    
    static var dataStoragePublisher = DataStoragePublisher()
    
    static var networkServiceResponseQueue: DispatchQueue = DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceResponseQueue" : "networkServiceResponseQueue", qos: .utility)

    
    static var dataStoreService: DataStorageService = {
        return DataStorageServiceImpl(dataStoragePublisher: AppStating.dataStoragePublisher)
    }()
    
    @Published var selectTabIndex: Int = TabbarTab.dashboardScreen.rawValue  {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
            if isQuickLink {
                selectTabIndex = TabbarTab.movies.rawValue
            }
        }
    }

    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text))

    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
                selectionScreen = AnyView(DashBoardScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppStating.dataStoreService.context)
                                            )
            case .movies:
                selectionScreen = AnyView(MovieSearchScreen(
                                            dataStorageService: AppStating.dataStoreService,
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppStating.dataStoreService.context)
                                            .environmentObject(self)
                                            .environmentObject(movieSearchVM)
                )
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
}
