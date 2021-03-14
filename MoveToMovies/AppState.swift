//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import CoreData
import TmdbAPI


final class AppState: ObservableObject {
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
    
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen())
    
    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
                selectionScreen = AnyView(DashBoardScreen())
            case .movies:
                selectionScreen = AnyView(MovieSearchScreen(actualColor: selectedTab.actualColor).environment(\.managedObjectContext, context))
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoveToMoviesModel")
        container.loadPersistentStores { (storeDescription, error)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            //print("🟢 Core Data stack has been initialized with description:\n \(storeDescription)")
        }
       
        return container
    }()
    
    @Published var context: NSManagedObjectContext!
    
    init() {
        makeContext()
    }
    
    func makeContext() {
        context = persistentContainer.newBackgroundContext()
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

}
