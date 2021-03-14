//
//  SwiftUIView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI
import UIControls

struct MovieSearchScreen: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var vm: MovieSearchScreenViewModel = .init()

    private var actualColor: Color
    
    @State var selectSegment: Int = 0
    
    private var segmentes: [String] = ["Search", "Popular"]
    
    @State var searchText: String = ""

    init(actualColor: Color) {
        self.actualColor = actualColor
    }
    
    var body: some View {
        VStack (spacing: 20){
            // Title
            Text("Movies")
                .titleStyle()
                .foregroundColor(actualColor)
            // Segment control
            Picker("", selection: $selectSegment) {
                ForEach(0..<segmentes.count) {
                    Text("\(segmentes[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])
            // Search
            if selectSegment == 0 {
                Group {
                    // Search bar
                    SearchBar(searchText: $searchText, actualColor: actualColor)
                    Spacer()
                    Circle().background(Color.blue).frame(width: 100, height: 100, alignment: .center)
                }
            } else if selectSegment == 1 {
                Group {
                    // Some...
                    Text("Some text")
                    Spacer()
                    Circle().background(Color.green).frame(width: 100, height: 100, alignment: .center)
                }
            }
        }.animation(.easeInOut)
        .onAppear{
            print("🍑", managedObjectContext)
            vm.setup(managedObjectContext)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchScreen(actualColor: Color(UIColor.darkText))
    }
}

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
