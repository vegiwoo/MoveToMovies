//
//  TabbarView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import UIControls

struct TabbarView: View {
    
    @EnvironmentObject var appState: AppState
    @Binding var selectionScreen: AnyView
    @State var selectionIndex: Int = 0
    
    @ObservedObject var vm: TabbarViewModel
    
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
                selectionScreen
                    .frame(height: (geometry.size.height / 12) * 11 )
                    .transition(.moveAndFade)
                TabBar(selectedIndex: $appState.selectTabIndex, tabBarItems: vm.tabBarItems, animanion: .easeInOut)
                    .frame(height: geometry.size.height / 12)
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(selectionScreen: .constant(AnyView(DashBoardScreen())), vm: TabbarViewModel())
    }
}
