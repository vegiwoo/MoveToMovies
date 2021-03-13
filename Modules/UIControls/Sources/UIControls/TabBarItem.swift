//
//  TabBarItem.swift
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

public struct TabBarItem {
    public let icon : Image
    public let title: String
    public let color: Color
    
    public init(icon: Image, title: String, color: Color){
        self.icon = icon
        self.title = title
        self.color = color
    }
    
    public init(sfSymbolName: String, title: String, color: Color) {
        self.icon = Image(systemName: sfSymbolName)
        self.title = title
        self.color = color
    }
}
#endif
