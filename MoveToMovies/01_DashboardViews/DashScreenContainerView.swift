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

    var body: some View {
        DashScreenRenderView(readinessUpdatePopularTmbdMovies: readinessUpdatePopularTmbdMovies, isQuickTransition: gotoDetailedView)
            .onAppear{
                appStore.send(AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.gotoDetailedView(false)))
            }
            .onChange(of: gotoDetailedView.wrappedValue) { (value) in
                if value {
                    appStore.send(AppAction.searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction.assignIndexSegmentControl(1)))
                    appStore.send(AppAction.tabbar(action: TabbarAction.indexChange(1)))
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
    private var gotoDetailedView: Binding<Bool> {
        appStore.binding(for: \.popularMovies.gotoDetailedView) {
            AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.gotoDetailedView($0))
        }
    }
}

struct DashScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DashScreenContainerView()
    }
}
