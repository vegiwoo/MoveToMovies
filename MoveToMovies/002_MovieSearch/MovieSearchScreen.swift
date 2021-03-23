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
    
    private var networkService: NetworkService
    
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false) ]
    ) var popularMovies: FetchedResults<MovieItem>

    var actualColor: Color
    var title: String
    
    @State var selectSegment: Int = 0
    private var segmentes: [String] = ["Search", "Popular"]
    
    @State var clearSearch: Bool = true

    init(networkService: NetworkService, actualColor: Color, title: String) {
        self.networkService = networkService
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
                    SearchBar(actualColor: actualColor, clearSearch: $clearSearch, searchTextLoading: $vm.searchTextLoading)
                    if clearSearch {
                        VStack {
                            Spacer().frame(width: 100, height: 100, alignment: .center)
                            ClearSearchView()
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            ForEach(vm.items, id: \.self) {item in
                                MovieCell(model: item).frame(width: 380, height: 120, alignment: .leading)
                                    .onAppear {
                                        if item == vm.items.last && !vm.isPageLoading {
                                            vm.loadPage()
                                        }
                                    }
                                
                            }
                        }
                    }
                }.transition(.move(edge: .leading))
            } else if selectSegment == 1 {
                Group {
                    List {
                        ForEach(popularMovies, id: \.self) { movie in
                            MovieCell(model: PopularMovieDTO(fromMovieItem: movie)).frame(width: 380, height: 120, alignment: .leading)
                        }
                    }
                }.transition(.move(edge: .trailing))
            }
        }.animation(.easeInOut)
        .onAppear{
            vm.setup(managedObjectContext, networkService: self.networkService)
        }.onChange(of: selectSegment) { value in
            if value == 1 {
                self.clearSearch = true
                vm.clearSearch()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchScreen(networkService: NetworkServiceImpl(apiResponseQueue: DispatchQueue.main, dataStoragePublisher: DataStoragePublisher()), actualColor: Color(UIColor.darkText), title: "Some screen")
    }
}


