//
//  SearchBar.swift
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI
import OmdbAPI

@available(iOS 13.0, *)
public struct SearchBar: View {
    
    private var placeholder: String
    private var actualColor: UIColor

    @State private var typingText = ""
    @Binding var searchText: String
    
    @Binding var movieSearchStatus: MovieSearchStatus {
        didSet {
            if movieSearchStatus == .initial {
                typingText = ""
            }
        }
    }
    @State var isClearButton: Bool = false
    
    public init(placeholder: String,  actualColor: UIColor,searchText: Binding<String>,  movieSearchStatus: Binding<MovieSearchStatus>) {
        self.placeholder = placeholder
        self.actualColor = actualColor
        self._searchText = searchText
        self._movieSearchStatus = movieSearchStatus
    }
    
    public var body: some View {
        HStack (spacing: 16) {
            TextField(placeholder, text: $typingText) { onEditionChanged in
                // Handle edition changed
            } onCommit: {
                // Tap search button
                if !typingText.isEmpty {
                    searchText = typingText
                    self.movieSearchStatus = .loading
                    //keyboardDismiss()
                } else {
                    self.movieSearchStatus = .initial
                }
                
            }
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .onTapGesture {
                movieSearchStatus = .typing
                withAnimation {
                    isClearButton = true
                }
            }
            .keyboardType(.webSearch)
            .animation(Animation.easeOut(duration: 0.1))
            
            if isClearButton {
                Group {
                    Button(action: {
                        // Tap clear button
                        movieSearchStatus = .initial
                        typingText = ""; searchText = ""
                        //keyboardDismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(actualColor))
                    }
                    .padding(.trailing, 36)
                    .transition(.move(edge: .trailing))
                    .animation(Animation.easeOut(duration: 0.1))
                    
                }.frame(width: 15, height: 15, alignment: .center)
            }
        }
        .onReceive(NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)) { _ in
            if typingText.isEmpty {
                isClearButton = false
                movieSearchStatus = .initial
                
            }
        }
    }
    
//    private func keyboardDismiss() {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        keyWindow?.endEditing(true)
//    }
}

@available(iOS 13.0, *)
public struct SearchBar_Previews: PreviewProvider {
    public static var previews: some View {
        SearchBar(placeholder: "Search something...", actualColor: .red, searchText: .constant("Some string"), movieSearchStatus: .constant(.initial))
    }
}
#endif

public enum MovieSearchStatus: CustomStringConvertible {
    case initial
    case typing
    case loading
    case getResults([MovieOmdbapiObject])
    case error
    
    public var description: String {
        switch self {
        case .initial:
            return "initial"
        case .typing:
            return "typing"
        case .loading:
            return "loading"
        case .getResults(_):
            return "getResults"
        case .error:
            return "error"
        }
    }
}

extension MovieSearchStatus: Equatable {
    public static func == (lhs: MovieSearchStatus, rhs: MovieSearchStatus) -> Bool {
        lhs.description == rhs.description
    }
    
    
}
