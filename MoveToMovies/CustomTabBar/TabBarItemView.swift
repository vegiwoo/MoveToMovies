//
//  TabBarItemView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 10.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

public struct TabBarItemView: View {
    
    @Binding var selected : Int
    public let index: Int
    public let item: TabBarItem
    
    var isSelected: Bool {
        selected == index
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

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarItemView(selected: .constant(0), index: 0, item: TabBarItem(sfSymbolName: "printer.dotmatrix.fill", title: "Printer", color: Color.red))
    }
}
#endif
