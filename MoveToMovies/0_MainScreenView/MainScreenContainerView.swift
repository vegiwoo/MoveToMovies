//
//  MainScreenContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 01.04.2021.
//

import SwiftUI
import Navigation

struct MainScreenContainerView: View, IContaierView {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject var navCoordinator: NavCoordinatorViewModel
    
    var body: some View {
        MainScreenRenderView(selectedIndex: tabbarSelectedIndex, selectedView: tabbarSelectedView, visibleTabbar: true)
            .environmentObject(appStore)
    }
}

/// Binding valiables
extension MainScreenContainerView {
    private var tabbarSelectedIndex: Binding<Int> {
        appStore.binding(for: \.tabBar.selectedIndex) {AppAction.tabbar(action: TabbarAction.indexChange($0))}
    }
    private var tabbarSelectedView: Binding<AnyView> {
        appStore.binding(for: \.tabBar.selectedView)
    }

}

struct MainScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenContainerView()
    }
}
