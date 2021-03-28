//
//  TabbarView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import UIControls

struct TabbarView: View, SizeClassAdjustable {
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    @EnvironmentObject var appState: AppState
    @Binding var selectionScreen: AnyView
    //@State var selectionIndex: Int = 0
    
    @ObservedObject var vm: TabbarViewModel
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
                selectionScreen
                    .frame(width: geometry.size.width,
                           height: isPad
                            ? (geometry.size.height / 11) * 10
                            : isPadOrLandscapeMax
                                ? (geometry.size.height / 6) * 5
                                : (geometry.size.height / 12) * 11)
                    .transition(.moveAndFade)
                TabBar(selectedIndex: $appState.selectTabIndex, tabBarItems: vm.tabBarItems, animanion: .easeInOut)
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


struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(selectionScreen: .constant(AnyView(DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text))), vm: TabbarViewModel())
    }
}
