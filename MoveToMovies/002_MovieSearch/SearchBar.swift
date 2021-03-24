//
//  SearchBar.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 22.03.2021.
//

import SwiftUI

struct SearchBar: View {
    
    @State private var text = ""
    @Binding var searchText: String
    @State private var isEditing = false
    var placeholder: String = "Search movie or TV show ..."
    var actualColor: Color
    
    @Binding var clearSearch: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text) { _ in
                //print(value)
            } onCommit: {
                // Press return buttomn
                if !text.isEmpty {
                    searchText = text
                }
                keyboardDismiss()
            }
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .onTapGesture {
                self.isEditing = true
                self.clearSearch = false
            }.keyboardType(.webSearch)
            
            if isEditing {
                Button(action: {
                    // Tap clear button
                    self.isEditing = false
                    self.text = ""
                    self.searchText = ""
                    clearSearch = true
                    keyboardDismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(actualColor)
                }
                .padding(.trailing, 36)
                .transition(.move(edge: .trailing))
                .animation(Animation.easeOut(duration: 0.2))
            }
        }
    }
    
    private func keyboardDismiss() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("Hello"), actualColor: .red, clearSearch: .constant(false))
    }
}
