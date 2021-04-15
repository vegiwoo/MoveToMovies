//
//  DashScreenContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import Navigation

struct DashScreenContainerView: View{
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack

    //@State var isQuickTransition: Bool  = false
    
    var body: some View {
        DashScreenRenderView(readinessUpdatePopularTmbdMovies: readinessUpdatePopularTmbdMovies, isQuickTransition: isQuickTransition)
            .onChange(of: appStore.state.popularMovies.isQuickTransition) { (value) in
                if value {
                    print(value)
                    print(appStore.state.popularMovies.selectedTMDBMovie?.title)
                    

//                    appStore.send(AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.assignIndexSegmentControl(1)))
//                    appStore.send(AppAction.tabbar(action: TabbarAction.indexChange(1)))
                }
            }.onDisappear {
                print("⬇️ DashScreenContainerView onDisappear")
            }
    }
}

/// Bindings variables
extension DashScreenContainerView {
    private var readinessUpdatePopularTmbdMovies: Binding<Bool> {
        appStore.binding(for: \.popularMovies.readinessUpdatePopularTmbdMovies)
    }
    private var selectedIndex: Binding<Int> {
        appStore.binding(for: \.tabBar.selectedIndex) {
            AppAction.tabbar(action: TabbarAction.indexChange($0))
        }
    }
    private var isQuickTransition: Binding<Bool> {
        appStore.binding(for: \.popularMovies.isQuickTransition) { _ in
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.getRandomMovie)
        }
    }
}

struct DashScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DashScreenContainerView()
    }
}
