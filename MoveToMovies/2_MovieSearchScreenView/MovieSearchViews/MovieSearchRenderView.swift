//
//  MovieSearchRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls
import Navigation

struct MovieSearchRenderView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let title: String
    let accentColor: UIColor
    
    private var segmentes: [String] = ["Search", "Popular"]
    @Binding var selectedIndexSegmentControl: Int
    @Binding var movieSearchStatus: MovieSearchStatus
    @Binding var searchQuery: String
    @Binding var foundMoviesPosters: [String: Data?]
    @Binding var infoMessage: (symbol: String, message: String)
    @Binding var foundMovies: [MovieOmdbapiObject]
    @Binding var needForFurtherLoad: Bool
    @Binding var progressLoad: Float
    @Binding var selectedOMDBMovie: MovieOmdbapiObject?
    @Binding var selectedTMDBMovie: MovieItem?
    
    @State var gotoDetail: Bool = false
    
    
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false) ]
    ) var popularMovies: FetchedResults<MovieItem>
    
    init(title: String,
         accentColor: UIColor,
         selectedIndexSegmentControl: Binding<Int>,
         movieSearchStatus: Binding<MovieSearchStatus>,
         searchQuery: Binding<String>,
         infoMessage: Binding<(symbol: String, message: String)>,
         foundMovies: Binding<[MovieOmdbapiObject]>,
         foundMoviesPosters: Binding<[String: Data?]>,
         needForFurtherLoad: Binding<Bool>,
         progressLoad: Binding<Float>,
         selectedOMDBMovie: Binding<MovieOmdbapiObject?>,
         selectedTMDBMovie: Binding<MovieItem?>
    ) {
        self.title = title
        self.accentColor = accentColor
        self._selectedIndexSegmentControl = selectedIndexSegmentControl
        self._movieSearchStatus = movieSearchStatus
        self._searchQuery = searchQuery
        self._infoMessage = infoMessage
        self._foundMovies = foundMovies
        self._foundMoviesPosters = foundMoviesPosters
        self._needForFurtherLoad = needForFurtherLoad
        self._progressLoad = progressLoad
        self._selectedOMDBMovie = selectedOMDBMovie
        self._selectedTMDBMovie = selectedTMDBMovie
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
                
                // Search movies
                if selectedIndexSegmentControl == 0 {
                    SearchBar(placeholder: "Search movie or TV Show...", actualColor: accentColor, searchText: $searchQuery,  movieSearchStatus: $movieSearchStatus)
                    
                    if movieSearchStatus.description == "getResults" ||
                        movieSearchStatus == .loading ||
                        movieSearchStatus == .endOfSearch {

                        ScrollViewReader { scrollProxy in
                            ScrollView {
                                LazyVStack {
                                    ForEach(foundMovies, id: \.self) {item in
                                        MovieCell(model: item, poster: foundMoviesPosters[item.imdbID!] ?? nil)
                                            .frame(width: 380, height: 120, alignment: .leading)
                                            .onAppear {
                                                if foundMovies.isLast(item) {
                                                    needForFurtherLoad = true
                                                }
                                            }.onTapGesture {
                                                selectedOMDBMovie = item
                                            }
                                    }
                                }
                            }.onAppear {
                                if let selectedMovie = selectedOMDBMovie {
                                    scrollProxy.scrollTo(selectedMovie, anchor: .center)
                                    self.selectedOMDBMovie = nil
                                }
                            }
                        }
                        
                        if movieSearchStatus == .loading {
                            ProgressView("", value: progressLoad, total: 100)
                                .frame(width: geometry.size.width, height: 3, alignment: .center)
                        }
                        
                        if movieSearchStatus == .endOfSearch {
                            Text("End of search").frame(width: 380, height: 30, alignment: .center)
                        }
                        
                    } else if movieSearchStatus == .initial || movieSearchStatus == .error  {
                        Spacer().frame(width: 100, height: 100, alignment: .center)
                        // Info View
                        VStack(spacing: 20) {
                            Image(systemName: infoMessage.symbol)
                                .font(Font.system(size: 150))
                            Text(infoMessage.message)
                                .font(Font.system(size: 36))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(Color(UIColor.systemGray4))
                        .transition(.opacity)
                        Spacer()
                    }
                    
                // Popular movies
                } else if selectedIndexSegmentControl == 1 {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            LazyVStack {
                                ForEach(popularMovies, id: \.self) {item in
                                    MovieCell(model: MovieItemDTO(item))
                                        .frame(width: 380, height: 120, alignment: .leading)
                                        .id(UUID())
                                        .onTapGesture {
                                            selectedTMDBMovie = item
                                        }
                                }
                            }
                        }.onAppear {
                            if let selectedMovie = selectedTMDBMovie {
                                scrollProxy.scrollTo(selectedMovie, anchor: .center)
                                self.selectedTMDBMovie = nil
                            }
                        }
                    }
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
                              movieSearchStatus: .constant(.initial),
                              searchQuery: .constant(""),
                              infoMessage: .constant((symbol: "magnifyingglass",
                                                      message: "Find your favorite\nmovie or TV series")),
                              foundMovies: .constant([]),
                              foundMoviesPosters: .constant([:]),
                              needForFurtherLoad: .constant(false),
                              progressLoad: .constant(50.0),
                              selectedOMDBMovie: .constant(MovieOmdbapiObject()),
                              selectedTMDBMovie: .constant(nil)
                    )
    }
}
