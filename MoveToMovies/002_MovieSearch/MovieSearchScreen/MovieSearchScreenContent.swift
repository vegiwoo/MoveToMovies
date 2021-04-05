//
//  MovieSearchScreenContent.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 27.03.2021.
//

import SwiftUI
import Navigation
import UIControls

struct MovieSearchScreenContent: View, BaseView {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppStating
    @EnvironmentObject var ncViewModel: NavCoordinatorViewModel
    @EnvironmentObject var vm: MovieSearchScreenViewModel
   
    private var networkService: NetworkService
    private var dataStorageService: DataStorageService
    
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false) ]
    ) var popularMovies: FetchedResults<MovieItem>

    var actualColor: UIColor
    var title: String
    
    @State var selectSegment: Int = 0
    private var segmentes: [String] = ["Search", "Popular"]
    
    @State var searchText: String = ""
    @State var clearSearch: Bool = true

    init(networkService: NetworkService, dataStorageService: DataStorageService, actualColor: UIColor, title: String) {
        self.networkService = networkService
        self.dataStorageService = dataStorageService
        self.actualColor = actualColor
        self.title = title
    }
    
    var body: some View {
        VStack (spacing: 20){
            if !appState.isQuickLink {
                // Title
                Text(title)
                    .titleStyle()
                    .foregroundColor(Color(actualColor))
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
                    
//                    Group {
//                        // Search bar
////                        SearchBar(placeholder: "Search movie or TV Show...", actualColor: actualColor, searchText: $searchText, clearSearch: $clearSearch)
//
//                        // Initial load indicator
//                        if vm.searchMovies.count == 0 && vm.isPageLoading {
//                            ActivityIndicator(style: .large, shouldAnimate: .constant(true)).frame(width: 30, height: 30, alignment: .center)
//                            Spacer()
//                        } else {
//                            if clearSearch {
//                                VStack {
//                                    Spacer().frame(width: 100, height: 100, alignment: .center)
//                                   // ClearSearchView()
//                                    Spacer()
//                                }
//                            } else {
//                                VStack {
//                                    // Search results list
//                                    List (vm.searchMovies) {item in
//                                        NavPushButton(destination: MovieDetailScreen(searchMovie: (item, vm.searchMoviePosters[item.id]))
//                                                        .environmentObject(appState)
//                                        ) {
//                                            MovieCell(model: item, poster: vm.searchMoviePosters[item.id])
//                                                .id(UUID())
//                                                .environmentObject(vm)
//                                                .onAppear {
//                                                    if vm.searchMovies.isLast(item) { vm.loadPage() }
//                                                }
//                                        }
//                                        .frame(width: 380, height: 120, alignment: .leading)
//                                    }
//                                    //ActivityIndicator(style: .medium, shouldAnimate: $vm.isPageLoading).frame(width: 30, height: 30, alignment: .center).transition(.opacity)
//                                }
//                            }
//                        }
//                    }
//                    .transition(.moveAndFade)
//
                } else if selectSegment == 1 {
                    Group {
                        List {
                            ForEach(popularMovies, id: \.self) { movie in
                                NavPushButton(destination: MovieDetailScreen(popularMovie: movie)
                                                .environmentObject(appState)
                                ) {
                                  //  MovieCell(model: PopularMovieDTO(fromMovieItem: movie))
                                }
                                .frame(width: 380, height: 120, alignment: .leading)
                            }
                        }
                    }.transition(.moveAndFade)
                }
            } else {
                EmptyView()
            }
        }
        
//        .animation(.easeInOut)
//        .onAppear{
//            vm.setup(ncViewModel: ncViewModel)
//
//            if let selectSegment = UserDefaults.standard.value(forKey: "selectSegment") as? Int {
//                self.selectSegment = selectSegment
//                UserDefaults.standard.removeObject(forKey: "selectSegment")
//            }
//            
//            if appState.isQuickLink, let randomMovie = vm.getRandomMovie() {
//                vm.navigationPush(destination: AnyView(MovieDetailScreen(popularMovie: randomMovie).environmentObject(appState)))
//                self.selectSegment = 1
//            }
//            print("⬆️ MovieSearchScreenContent onAppear")
//        }.onChange(of: selectSegment) { value in
//            if value == 1 {
//                self.clearSearch = true
//                vm.clearSearch()
//            }
//        }.onChange(of: searchText) {value in
//            if value == "" {
//                vm.clearSearch()
//            } else {
//                vm.searchText = value
//                vm.loadPage()
//            }
//   
//        }
//        .onDisappear{
//            UserDefaults.standard.setValue(searchText, forKey: "searchText")
//            UserDefaults.standard.setValue(selectSegment, forKey: "selectSegment")
//            print("⬇️ MovieSearchScreenContent onDisappear")
//        }
    }
}

struct MovieSearchScreenContent_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchScreenContent(networkService: AppStating.networkService, dataStorageService: AppStating.dataStoreService, actualColor: .orange, title: "Hello")
       
    }
}
