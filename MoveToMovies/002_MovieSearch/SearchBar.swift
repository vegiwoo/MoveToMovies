//
//  SearchBar.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 22.03.2021.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var isEditing = false
    var placeholder: String = "Search movie or TV show ..."
    var actualColor: Color
    
    var body: some View {
            HStack {
                TextField(placeholder, text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        self.isEditing = true
                    }

                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchText = ""

                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(actualColor)
                    }
                    .padding(.trailing, 36)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
        }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), actualColor: .red)
    }
}
