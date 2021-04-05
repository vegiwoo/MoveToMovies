//
//  ClearSearchView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 23.03.2021.
//

import SwiftUI

struct ClearSearchView: View {
    
    @Binding var sfSymbolName: String
    @Binding var message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: sfSymbolName)
                .font(Font.system(size: 150))
            Text(message)
                .font(Font.system(size: 36))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(Color(UIColor.systemGray4))
    }
}

struct ClearSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ClearSearchView(sfSymbolName: .constant("magnifyingglass"),
                        message: .constant("Find your favorite\nmovie or TV series"))
    }
}
