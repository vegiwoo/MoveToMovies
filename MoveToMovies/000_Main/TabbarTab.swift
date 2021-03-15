//
//  TabbarTab.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI

enum TabbarTab: Hashable, CaseIterable {
    case dashboardScreen
    case movies
    case aboutUSScreen
    
    var actualColor: Color {
        switch self {
        case .dashboardScreen: return Color(UIColor.systemIndigo)
        case .movies: return Color(UIColor.systemPurple)
        case .aboutUSScreen: return  Color(UIColor.systemOrange)
        }
    }
    
    var rawValue: Int {
        switch self {
        case .dashboardScreen: return 0
        case .movies: return 1
        case .aboutUSScreen: return 2
        }
    }
    
    var text: String {
        switch self {
        case .dashboardScreen: return "Dashboard"
        case .movies: return "Movies"
        case .aboutUSScreen: return "About us"
        }
    }
    
    var icon: Image {
        switch self {
        case .dashboardScreen: return Image(systemName: "list.dash")
        case .movies: return Image(systemName: "tv")
        case .aboutUSScreen:  return Image(systemName: "info")
        }
    }
}
