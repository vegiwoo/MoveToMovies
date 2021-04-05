//
//  MovieSearchRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import UIControls

struct MovieSearchRenderView: View {
    
    let title: String
    let accentColor: UIColor
    
    private var segmentes: [String] = ["Search", "Popular"]
    @Binding var selectedIndexSegmentControl: Int
    @Binding var searchQuery: String
    @Binding var clearSearch: Bool
    @Binding var infoMessage: (symbol: String, message: String)
    
    init(title: String,
         accentColor: UIColor,
         selectedIndexSegmentControl: Binding<Int>,
         searchQuery: Binding<String>,
         clearSearch: Binding<Bool>,
         infoMessage: Binding<(symbol: String, message: String)>
         ) {
        self.title = title
        self.accentColor = accentColor
        self._selectedIndexSegmentControl = selectedIndexSegmentControl
        self._searchQuery = searchQuery
        self._clearSearch = clearSearch
        self._infoMessage = infoMessage
    }
    
    var body: some View {
        GeometryReader{geometry in
            VStack(spacing: 20) {
                Text(title)
                    .foregroundColor(Color(accentColor))
                    .titleStyle()
                Picker("", selection: $selectedIndexSegmentControl) {
                    ForEach(0..<segmentes.count) {
                        Text("\(segmentes[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedIndexSegmentControl == 0 {
                    SearchBar(placeholder: "Search movie or TV Show...", actualColor: accentColor, searchText: $searchQuery, clearSearch: $clearSearch)
                    
                    if clearSearch {
                        Spacer().frame(width: 100, height: 100, alignment: .center)
                        ClearSearchView(sfSymbolName: $infoMessage.symbol, message: $infoMessage.message)
                        Spacer()
                    }
                } else {
                    
                }
            }
            
        }
    }
}

struct MovieSearchRenderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchRenderView(title: "Some title",
                              accentColor: .brown,
                              selectedIndexSegmentControl: .constant(0),
                              searchQuery: .constant(""),
                              clearSearch: .constant(true),
                              infoMessage: .constant((symbol: "magnifyingglass",
                                                      message: "Find your favorite\nmovie or TV series"))
                    )
    }
}
