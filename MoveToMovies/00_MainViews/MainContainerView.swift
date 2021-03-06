//
//  MainScreenContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 01.04.2021.
//

import SwiftUI
import Navigation

struct MainContainerView: View ,IContaierView {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel
    
    var body: some View {
        MainView(selectedIndex: tabbarSelectedIndex, selectedView: tabbarSelectedView, visibleTabbar: isVisibleTabbar, updateData: updateData)
            .environmentObject(appStore)
    }
}

/// Binding valiables
extension MainContainerView {
    
    private var updateData: Binding<Bool> {
        appStore.binding(for: \.popularMovies.updateData) {_ in AppAction.popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction.loadGenres)}
    }
    
    private var isVisibleTabbar: Binding<Bool> {
        appStore.binding(for: \.tabBar.isVisibleTabBar) {
            AppAction.tabbar(action: TabbarAction.hideTabbar($0))
        }
    }
    
    private var tabbarSelectedIndex: Binding<Int> {
        appStore.binding(for: \.tabBar.selectedIndex) {AppAction.tabbar(action: TabbarAction.indexChange($0))}
    }
    private var tabbarSelectedView: Binding<AnyView> {
        appStore.binding(for: \.tabBar.selectedView)
    }

}

struct MainScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerView()
    }
}
