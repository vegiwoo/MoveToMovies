//
//  ClearSearchView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 23.03.2021.
//

import SwiftUI

struct ClearSearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass").font(Font.system(size: 150))
            Text("Find your favorite\nmovie or TV series").font(Font.system(size: 36)).lineLimit(2).multilineTextAlignment(.center)
        }.foregroundColor(Color(UIColor.systemGray4))
    }
}

struct ClearSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ClearSearchView()
    }
}
