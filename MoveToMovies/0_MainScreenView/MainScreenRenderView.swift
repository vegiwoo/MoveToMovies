//
//  MainScreenRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 01.04.2021.
//

import SwiftUI
import UIControls

struct MainScreenRenderView: View, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @Binding var selectedIndex: Int
    @Binding var selectedView: AnyView
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
                selectedView
                    .frame(width: geometry.size.width,
                                   height: isPad
                                    ? (geometry.size.height / 11) * 10
                                    : isPadOrLandscapeMax
                                        ? (geometry.size.height / 6) * 5
                                        : (geometry.size.height / 12) * 11)
                    .transition(.moveAndFade)
                TabBar(tabbarSelectedIndex: $selectedIndex, tabBarItems: appStore.state.tabBar.tabBarItems, animanion: Animation.easeInOut(duration: 0.4))
                    .frame(width: isPad
                                ? geometry.size.width / 2
                                : isLandscape
                                    ? geometry.size.width / 2
                                    : geometry.size.width,
                           height: isPad
                            ? geometry.size.height / 11
                            : isPadOrLandscapeMax
                                ? geometry.size.height / 6
                            : geometry.size.height / 12)
                    .padding(.top, 10)
            }
        }
    }
}

struct MainScreenRenderView_Previews: PreviewProvider {
    
    static let appStore = MoveToMoviesApp.createStore()
    static var previews: some View {
        MainScreenRenderView(
            selectedIndex: .constant(0),
            selectedView: .constant(AnyView(EmptyView()))
        ).environmentObject(appStore)
    }
}
