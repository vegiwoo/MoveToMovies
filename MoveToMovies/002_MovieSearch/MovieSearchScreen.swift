//
//  SwiftUIView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI
import UIControls

struct MovieSearchScreen: View, BaseView {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var vm: MovieSearchScreenViewModel = .init()

    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false)
    ]) var popularMovies: FetchedResults<MovieItem>

    var actualColor: Color
    var title: String
    
    @State var selectSegment: Int = 0
    
    private var segmentes: [String] = ["Search", "Popular"]
    
    @State var searchText: String = ""

    init(actualColor: Color, title: String) {
        self.actualColor = actualColor
        self.title = title
    }
    
    var body: some View {
        VStack (spacing: 20){
            // Title
            Text(title)
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
        
                }
            } else if selectSegment == 1 {
                Group {
                    Spacer()
                    List {
                        ForEach(popularMovies, id: \.self) { movie in
                            MovieCell(model: PopularMovieDTO(fromMovieItem: movie)).frame(width: 380, height: 120, alignment: .leading)
                        }
                    }
                }
            }
        }.animation(.easeInOut)
        .onAppear{
            vm.setup(managedObjectContext)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchScreen(actualColor: Color(UIColor.darkText), title: "Some screen")
    }
}


