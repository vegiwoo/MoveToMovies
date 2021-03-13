//
//  TabbarTab.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI

enum TabbarTab: Hashable, CaseIterable, CustomStringConvertible {
    case dashboardScreen
    case movies
    case aboutUSScreen
    
    var description: String {
        switch self {
        case .dashboardScreen: return "Dashboard Screen"
        case .movies: return "Movies Screen"
        case .aboutUSScreen: return "About us Screen"
        }
    }
    
    var rawValue: Int {
        switch self {
        case .dashboardScreen: return 0
        case .movies: return 1
        case .aboutUSScreen: return 2
        }
    }
    
    var text: Text {
        switch self {
        case .dashboardScreen:
            return Text("Dashboard")
        case .movies:
            return Text("Movies")
        case .aboutUSScreen:
            return Text("About us")
        }
    }
    
    var icon: Image {
        switch self {
        case .dashboardScreen:
            return Image(systemName: "list.dash")
        case .movies:
            return Image(systemName: "tv")
        case .aboutUSScreen:
            return Image(systemName: "info")
        }
    }
}
