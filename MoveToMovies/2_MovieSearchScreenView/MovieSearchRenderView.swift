//
//  MovieSearchRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls

struct MovieSearchRenderView: View {
    
    let title: String
    let accentColor: UIColor
    
    private var segmentes: [String] = ["Search", "Popular"]
    @Binding var selectedIndexSegmentControl: Int
    @Binding var movieSearchStatus: MovieSearchStatus
    @Binding var searchQuery: String
    @Binding var infoMessage: (symbol: String, message: String)
    @Binding var foundMovies: [MovieOMDBWithPosterItem]
    @Binding var needForFurtherLoad: Bool
    @Binding var progressLoad: Float
    
    init(title: String,
         accentColor: UIColor,
         selectedIndexSegmentControl: Binding<Int>,
         movieSearchStatus: Binding<MovieSearchStatus>,
         searchQuery: Binding<String>,
         infoMessage: Binding<(symbol: String, message: String)>,
         foundMovies: Binding<[MovieOMDBWithPosterItem]>,
         needForFurtherLoad: Binding<Bool>,
         progressLoad: Binding<Float>
         ) {
        self.title = title
        self.accentColor = accentColor
        self._selectedIndexSegmentControl = selectedIndexSegmentControl
        self._movieSearchStatus = movieSearchStatus
        self._searchQuery = searchQuery
        self._infoMessage = infoMessage
        self._foundMovies = foundMovies
        self._needForFurtherLoad = needForFurtherLoad
        self._progressLoad = progressLoad
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

                    if movieSearchStatus == .getResults || movieSearchStatus == .loading  {
                        List(foundMovies, id: \.self) {item in
                            MovieCell(model: item.movie, poster: item.poster)
                                .frame(width: 380, height: 120, alignment: .leading)
                                .onAppear {
                                    if foundMovies.isLast(item) {
                                        needForFurtherLoad = true
                                    }
                                }
                        }
                    } else {
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
                    
                    if movieSearchStatus == .loading {
                        ProgressView("", value: progressLoad, total: 100)
                            .frame(width: geometry.size.width, height: 3, alignment: .center)
                        
                    }

                // Popular movies
                } else if selectedIndexSegmentControl == 1 {
                    
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
                              foundMovies: .constant([]), needForFurtherLoad: .constant(false), progressLoad: .constant(50.9)
                    )
    }
}


