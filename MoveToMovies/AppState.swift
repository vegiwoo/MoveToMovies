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

final class AppState: ObservableObject {
<<<<<<< HEAD
=======

    static var dataStoragePublisher = DataStoragePublisher()
    
    static var networkService: NetworkService =
        NetworkServiceImpl(apiResponseQueue: AppState.networkServiceResponseQueue, dataStoragePublisher: dataStoragePublisher)
    
    static var networkServiceResponseQueue: DispatchQueue = DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceResponseQueue" : "networkServiceResponseQueue", qos: .utility)

    
    static var dataStoreService: DataStorageService = {
        return DataStorageServiceImpl(networkResponseQueue: AppState.networkServiceResponseQueue, networkPublisher: networkService.networkServicePublisher, dataStoragePublisher: AppState.dataStoragePublisher)
    }()
    
>>>>>>> dev
    @Published var selectTabIndex: Int = TabbarTab.dashboardScreen.rawValue  {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
<<<<<<< HEAD
            //selectionTab = .popularMoviesScreen
            randomMovie = isQuickLink == true ? appViewModel.getRandomMovie() : nil
=======
            if isQuickLink {
                selectTabIndex = TabbarTab.movies.rawValue
            }
>>>>>>> dev
        }
    }

    
<<<<<<< HEAD
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen())
=======
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text))
>>>>>>> dev
    
    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
<<<<<<< HEAD
                selectionScreen = AnyView(DashBoardScreen())
            case .popularMoviesScreen:
                selectionScreen = AnyView(PopularMoviesScreen())
=======
                selectionScreen = AnyView(DashBoardScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.dataStoreService.context)
                                            )
            case .movies:
                selectionScreen = AnyView(MovieSearchScreen(
                                            networkService: AppState.networkService,
                                            dataStorageService: AppState.dataStoreService,
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.dataStoreService.context)
                                            .environmentObject(self))
>>>>>>> dev
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
}
