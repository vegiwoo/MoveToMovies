//
//  SwiftUIView.swift
//  
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct TabBarItemView: View {
    
    @Binding var selected : Int
    public let index: Int
    public let item: TabBarItem
    
    var isSelected: Bool {
        selected == index
    }
    
    public init (selected: Binding<Int>,index: Int, item: TabBarItem) {
        self._selected = selected
        self.index = index
        self.item = item
    }

    public var body: some View {
        HStack {
            item.icon
                .imageScale(.large)
                .foregroundColor(isSelected ? item.color : .primary)
            
            if isSelected {
                Text(item.title)
                    .foregroundColor(item.color)
                    .font(.caption)
                    .fontWeight(.bold)
                    .transition(.scale)
            }
        }
        .padding()
        .background(
            Capsule().fill(isSelected ? item.color.opacity(0.2) : Color.clear))
    }
}

@available(iOS 13.0, *)
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarItemView(selected: .constant(0), index: 0, item: TabBarItem(sfSymbolName: "printer.dotmatrix.fill", title: "Printer", color: Color.red))
    }
}
#endif
