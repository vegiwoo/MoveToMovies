//
//  SearchBar.swift
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct SearchBar: View {
    
    private var placeholder: String
    private var actualColor: UIColor

    @State private var typingText = ""
    @Binding var searchText: String
    @State var searchBarState: SearchBarState = .initial {
        didSet {
            if searchBarState == .initial {
                typingText = ""
            }
        }
    }
    
    @Binding var clearSearch: Bool
    
    public init(placeholder: String,  actualColor: UIColor,searchText: Binding<String>, clearSearch: Binding<Bool>) {
        self.placeholder = placeholder
        self.actualColor = actualColor
        self._clearSearch = clearSearch
        self._searchText = searchText
    }
    
    public var body: some View {
        HStack {
            TextField(placeholder, text: $typingText) { onEditionChanged in
                // Handle edition changed
            } onCommit: {
                // Tap search button
                if !typingText.isEmpty {
                    searchText = typingText
                    self.searchBarState = .search
                } else {
                    self.searchBarState = .initial
                }
                keyboardDismiss()
            }
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .onTapGesture {
                searchBarState = .typing
                clearSearch = false
            }.keyboardType(.webSearch)
            
            if searchBarState == .typing {
                Button(action: {
                    // Tap clear button
                    searchBarState = .initial
                    typingText = ""; searchText = ""
                    clearSearch = true
                    keyboardDismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(actualColor))
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

@available(iOS 13.0, *)
public struct SearchBar_Previews: PreviewProvider {
    public static var previews: some View {
        SearchBar(placeholder: "Search something...", actualColor: .red, searchText: .constant("Some string"), clearSearch: .constant(false))
    }
}
#endif

enum SearchBarState {
    case initial, typing, search
}
