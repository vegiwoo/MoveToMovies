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
        TabBarItem(sfSymbolName: "list.dash", title: "Dashboard", color: Color(UIColor.systemIndigo)),
        TabBarItem(sfSymbolName: "tv", title: "Popular Movies", color: Color(UIColor.systemPurple)),
        TabBarItem(sfSymbolName: "info", title: "About us", color: Color(UIColor.systemOrange)),
    ]
}
