//
//  MovieSearchScreenContent.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 27.03.2021.
//

import SwiftUI
import Navigation

struct MovieSearchScreenContent: View, BaseView {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ncViewModel: NavCoordinatorViewModel
    @ObservedObject var vm: MovieSearchScreenViewModel = .init()
   
    private var networkService: NetworkService
    private var dataStorageService: DataStorageService
    
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false) ]
    ) var popularMovies: FetchedResults<MovieItem>

    var actualColor: Color
    var title: String
    
    @State var selectSegment: Int = 0
    private var segmentes: [String] = ["Search", "Popular"]
    
    @State var searchText: String = ""
    @State var clearSearch: Bool = true

    init(networkService: NetworkService, dataStorageService: DataStorageService, actualColor: Color, title: String) {
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
                        SearchBar(searchText: $searchText, actualColor: actualColor, clearSearch: $clearSearch)
                        
                        if vm.items.count == 0 && vm.isPageLoading {
                            ActivityIndicator(shouldAnimate: .constant(true), style: .large).frame(width: 30, height: 30, alignment: .center)
                            Spacer()
                        } else {
                            if clearSearch {
                                VStack {
                                    Spacer().frame(width: 100, height: 100, alignment: .center)
                                    ClearSearchView()
                                    Spacer()
                                }
                            } else {
                                VStack {
                                    List (vm.items) {item in
                                        MovieCell(model: item)
                                            .id(UUID())
                                            .frame(width: 380, height: 120, alignment: .leading)
                                            .environmentObject(vm)
                                            .onAppear {
                                                if vm.items.isLast(item) { vm.loadPage() }
                                            }
                                    }
                                    ActivityIndicator(shouldAnimate: $vm.isPageLoading,style: .medium).frame(width: 30, height: 30, alignment: .center).transition(.opacity)
                                }
                            }
                        }
                    }.transition(.moveAndFade)
                } else if selectSegment == 1 {
                    Group {
                        List {
                            ForEach(popularMovies, id: \.self) { movie in
                                NavPushButton(destination: MovieDetailScreen(movie: movie)
                                                .environmentObject(vm)
                                                .environmentObject(appState)
                                ) {
                                    MovieCell(model: PopularMovieDTO(fromMovieItem: movie))
                                }
                                .frame(width: 380, height: 120, alignment: .leading)
                                
                            }
                        }
                    }.transition(.moveAndFade)
                }
            } else {
                EmptyView()
            }
            
            
            
        }.animation(.easeInOut)
        .onAppear{
            vm.setup(managedObjectContext, networkService: self.networkService, dataStorageService: dataStorageService, ncViewModel: ncViewModel)

            if let selectSegment = UserDefaults.standard.value(forKey: "selectSegment") as? Int {
                self.selectSegment = selectSegment
                UserDefaults.standard.removeObject(forKey: "selectSegment")
            }
            
            if appState.isQuickLink, let randomMovie = vm.getRandomMovie() {
                vm.navigationPush(destination: AnyView(MovieDetailScreen(movie: randomMovie)
                                                        .environmentObject(vm)
                                                        .environmentObject(appState)))
                self.selectSegment = 1
            }
            
            
        }.onChange(of: selectSegment) { value in
            if value == 1 {
                self.clearSearch = true
                vm.clearSearch()
            }
        }.onChange(of: searchText) {value in
            if value == "" {
                vm.clearSearch()
            } else {
                vm.searchText = value
                vm.loadPage()
            }
        }.onDisappear{
            UserDefaults.standard.setValue(selectSegment, forKey: "selectSegment")
        }
    }
}
