//
//  TabbarView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct TabbarView: View {
    
    @EnvironmentObject var appState: AppState
    
    @Binding var selectionScreen: AnyView
    
    @State var selectionIndex: Int = 0
    
    var tabBarItems: [TabBarItem] = [
        TabBarItem(sfSymbolName: "list.dash", title: "Dashboard", color: .red),
        TabBarItem(sfSymbolName: "tv", title: "Popular Movies", color: .green),
        TabBarItem(sfSymbolName: "info", title: "About us", color: .blue),
    ]

    var body: some View {
        GeometryReader {geometry in
            VStack {
                selectionScreen.frame(height: (geometry.size.height / 10) * 9 )
                TabBar(selectedIndex: $appState.selectTabIndex, tabBarItems: tabBarItems, animanion: .easeInOut).frame(height: geometry.size.height / 10)
            }
        } 
    }
}

//struct TabbarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabbarView()
//    }
//}

enum TabbarTab: Hashable, CaseIterable, CustomStringConvertible {
    case dashboardScreen
    case popularMoviesScreen
    case aboutUSScreen
    
    var description: String {
        switch self {
        case .dashboardScreen: return "Dashboard Screen"
        case .popularMoviesScreen: return "Popular Movies Screen"
        case .aboutUSScreen: return "About us Screen"
        }
    }
    
    
    var rawValue: Int {
        switch self {
        case .dashboardScreen: return 0
        case .popularMoviesScreen: return 1
        case .aboutUSScreen: return 2
        }
    }
    
    
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
