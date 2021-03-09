//
//  TabbarView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct TabbarView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectionTab) {
            NavigationHost().environmentObject(appState.navigation).tabItem {
                TabbarView.Tab.dashboardScreen.icon
                TabbarView.Tab.dashboardScreen.text
            }.tag(TabbarView.Tab.dashboardScreen)
            NavigationHost().environmentObject(appState.navigation).tabItem {
                TabbarView.Tab.popularMoviesScreen.icon
                TabbarView.Tab.popularMoviesScreen.text
            }.tag(TabbarView.Tab.popularMoviesScreen)
            NavigationHost().environmentObject(appState.navigation).tabItem {
                TabbarView.Tab.aboutUSScreen.icon
                TabbarView.Tab.aboutUSScreen.text
            }.tag(TabbarView.Tab.aboutUSScreen)
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

extension TabbarView {
    enum Tab: Hashable {
        case dashboardScreen
        case popularMoviesScreen
        case aboutUSScreen
        
        var text: Text {
            switch self {
            case .dashboardScreen:
                return Text("Dashboard")
            case .popularMoviesScreen:
                return Text("Popular")
            case .aboutUSScreen:
                return Text("About us")
            }
        }
        
        var icon: Image {
            switch self {
            case .dashboardScreen:
                return Image(systemName: "list.dash")
            case .popularMoviesScreen:
                return Image(systemName: "tv")
            case .aboutUSScreen:
                return Image(systemName: "info")
            }
        }
    }
}
