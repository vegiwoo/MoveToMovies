//
//  MoveToMoviesApp.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI

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
    
    var body: some Scene {
        
        let appState: AppState = .init()
        
        WindowGroup {
            MainScreen()
                .environmentObject(appState)
                .environment(\.managedObjectContext, AppState.dataStoreService.context)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("App is in background")
                AppState.dataStoreService.saveContext()
            case .inactive:
                print("App is inactive")
                AppState.dataStoreService.saveContext()
            case .active:
                print("App is active")
            @unknown default:
                print("App is in ...?")
            }
        }
    }
}
