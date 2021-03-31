//
//  TabBarItem.swift
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI
@available(iOS 13.0, *)
public struct TabBarItem {
    public let icon : Image
    public let title: String
    public let color: UIColor
    
    public init(icon: Image, title: String, color: UIColor){
        self.icon = icon
        self.title = title
        self.color = color
    }
    
    public init(sfSymbolName: String, title: String, color: UIColor) {
        self.icon = Image(systemName: sfSymbolName)
        self.title = title
        self.color = color
    }
}
#endif
