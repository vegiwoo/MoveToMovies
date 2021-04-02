//
//  MainScreenContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 01.04.2021.
//

import SwiftUI

struct MainScreenContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @State var tabbarSelectedIndex: Int
    @State var selectedView: AnyView
   
    var body: some View {
        MainScreenRenderView(selectedIndex: $tabbarSelectedIndex, selectedView: $selectedView)
            .environmentObject(appStore)
            .onChange(of: tabbarSelectedIndex) { value in
                appStore.send(AppAction.tabbar(action: TabbarAction.indexChange(value)))
                withAnimation(Animation.easeInOut(duration: 0.4)) {
                    selectedView = appStore.state.tabBar.selectedView
                }
            }
    }
}

struct MainScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenContainerView(tabbarSelectedIndex: 2, selectedView: AnyView(EmptyView()))
    }
}
