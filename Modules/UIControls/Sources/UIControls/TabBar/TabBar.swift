//
//  TabBar.swift
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct TabBar: View {
    @Binding public var tabbarSelectedIndex: Int 
    
    public let tabBarItems: [TabBarItem]
    public let animanion: Animation
    
    public init (tabbarSelectedIndex: Binding<Int>, tabBarItems: [TabBarItem], animanion: Animation) {
        self._tabbarSelectedIndex = tabbarSelectedIndex
        self.tabBarItems = tabBarItems
        self.animanion = animanion
    }
    
    func itemView(at index: Int) -> some View {
        Button(action: {
            withAnimation(animanion){
                self.tabbarSelectedIndex = index
            }
        }) {
            TabBarItemView(selected: $tabbarSelectedIndex,
                           index: index,
                           item: tabBarItems[index])
        }
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<tabBarItems.count) {index in
                itemView(at: index)
                
                if index != tabBarItems.count - 1 {
                    Spacer()
                }
                
            }
        }
        .padding()
    }
}

@available(iOS 13.0, *)
public struct TabBar_Previews: PreviewProvider {
    public static var previews: some View {
        TabBar(tabbarSelectedIndex: .constant(4), tabBarItems: [
            TabBarItem(sfSymbolName: "printer.dotmatrix.fill",
                       title: "Printer", color: .red),
            TabBarItem(sfSymbolName: "scanner.fill",
                       title: "Scanner", color: .orange),
            TabBarItem(sfSymbolName: "apps.iphone",
                       title: "Phone", color: .green),
            TabBarItem(sfSymbolName: "applewatch",
                       title: "Watch", color: .yellow),
            TabBarItem(sfSymbolName: "4k.tv.fill",
                       title: "TV", color: .blue)
        ], animanion: .default)
    }
}
#endif
