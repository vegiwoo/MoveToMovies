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

    static var dataStorePublisher = PassthroughSubject<Any,Never>()
    
    static var networkService: NetworkService =
        NetworkServiceImpl(apiResponseQueue: AppState.networkServiceResponseQueue, dataStorePublisher: dataStorePublisher)
    
    static var networkServiceResponseQueue: DispatchQueue = DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceResponseQueue" : "networkServiceResponseQueue", qos: .utility)

    
    static var dataStoreService: DataStorageService = {
        return DataStorageServiceImpl(networkResponseQueue: AppState.networkServiceResponseQueue, networkPublisher: networkService.networkServicePublisher, dataStorePublisher: AppState.dataStorePublisher)
    }()
    
    @Published var selectTabIndex: Int = TabbarTab.dashboardScreen.rawValue  {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
            //selectionTab = .popularMoviesScreen
            randomMovie = isQuickLink == true ? appViewModel.getRandomMovie() : nil
        }
    }
    @Published var randomMovie: Movie?
    
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text))
    
    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
                selectionScreen = AnyView(DashBoardScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.dataStoreService.context))
            case .movies:
                selectionScreen = AnyView(MovieSearchScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.dataStoreService.context))
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
}
