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
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App is terminate")
    }
}

@main
struct MoveToMoviesApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let appStore: AppStore<AppState, AppAction, AppEnvironment>

    init() {
        ContainerHolder.container = Container()
        self.appStore = MoveToMoviesApp.createStore()
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreenContainerView()
                .environmentObject(appStore)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
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
    
    static func createStore() -> AppStore<AppState, AppAction, AppEnvironment> {
        return AppStore(initialState: .init(
                            tabBar: TabBarState(),
                            searchMovies: SearchMoviesState.init(
                                foundMovies: []),
                            popularMovies: PopularMoviesState.init()),
                        reducer: appReducer,
                        environment: AppEnvironment(
                            container: ContainerHolder.container,
                            args: ()))
    }
}

/// Extensions to hide keyboard on tap on empty space
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
