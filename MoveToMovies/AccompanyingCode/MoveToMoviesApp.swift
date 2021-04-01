//
//  MoveToMoviesApp.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import Architecture

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //print(">> your code here !!")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.removeObject(forKey: "searchText")
    }
}

@main
struct MoveToMoviesApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        ContainerHolder.container = Container()
    }
    
    var body: some Scene {

        let appStore = AppStore(initialState: .init(
                                    searchMovies: SearchMoviesState.init(foundFilms: []),
                                    popularMovies: PopularMoviesState.init()),
                                reducer: appReducer,
                                environment: AppEnvironment(
                                    container: ContainerHolder.container,
                                    args: ()))
        WindowGroup {
            MainScreen()
                .environmentObject(appStore)
                //.environmentObject(appState)
                //.environment(\.managedObjectContext, AppStating.dataStoreService.context)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("App is in background")
                AppStating.dataStoreService.saveContext()
            case .inactive:
                print("App is inactive")
                AppStating.dataStoreService.saveContext()
            case .active:
                print("App is active")
            @unknown default:
                print("App is in ...?")
            }
        }
    }
}
