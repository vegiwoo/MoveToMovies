//
//  TabbarViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI
import UIControls

final class TabbarViewModel: ObservableObject {
    var tabBarItems: [TabBarItem] = [
        TabBarItem(sfSymbolName: "list.dash", title: "Dashboard", color: TabbarTab.dashboardScreen.actualColor),
        TabBarItem(sfSymbolName: "tv", title: "Popular Movies", color: TabbarTab.movies.actualColor),
        TabBarItem(sfSymbolName: "info", title: "About us", color: TabbarTab.aboutUSScreen.actualColor),
    ]
}
