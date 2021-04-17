//
//  MoviesSearchView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.04.2021.
//

import SwiftUI
import OmdbAPI
import UIControls

struct MoviesSearchRenderView: View {

    @Binding var accentColor: UIColor
    @Binding var searchQuery: String
    @Binding var movieSearchStatus: MovieSearchStatus
    @Binding var foundItems: [FoundItem]
    @Binding var needForFurtherLoad: Bool
    @Binding var selectedOMDBMovie: FoundItem?
    @Binding var progressLoad: Double
    
    init(accentColor: Binding<UIColor>,
         searchQuery: Binding<String>,
         movieSearchStatus: Binding<MovieSearchStatus>,
         foundItems: Binding<[FoundItem]>,
         needForFurtherLoad: Binding<Bool>,
         selectedOMDBMovie: Binding<FoundItem?>,
         progressLoad: Binding<Double>) {
        self._accentColor = accentColor
        self._searchQuery = searchQuery
        self._movieSearchStatus = movieSearchStatus
        self._foundItems = foundItems
        self._needForFurtherLoad = needForFurtherLoad
        self._selectedOMDBMovie = selectedOMDBMovie
        self._progressLoad = progressLoad
    }
    
    var body: some View {
        VStack {
            SearchBar(placeholder: "Search movie or TV Show...", actualColor: accentColor, searchText: $searchQuery,  movieSearchStatus: $movieSearchStatus)
            
            switch movieSearchStatus {
            case MovieSearchStatus.initial, .error:
                // Info View
                Spacer().frame(width: 100, height: 100, alignment: .center)
                VStack(spacing: 20) {
                    if let sfSymbol = movieSearchStatus.info.sfSymbol, let message = movieSearchStatus.info.message {
                        if movieSearchStatus == .initial || movieSearchStatus == .error {
                            Image(systemName: sfSymbol)
                                .font(Font.system(size: 150))
                        }
                        Text(message)
                            .font(Font.system(size: 36))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    } else {
                        EmptyView()
                    }
                }
                .foregroundColor(Color(UIColor.systemGray4))
                .transition(.opacity)
                Spacer()
            case MovieSearchStatus.endOfLoadSession,.endOfSearch, .loading:
                GeometryReader {geometry in
                    VStack {
                        ScrollViewReader { scrollProxy in
                            List(foundItems, id: \.self) {item in
                                MovieCell(model: item.movie, poster: item.posterData)
                                    .frame(width: geometry.size.width - 40, height: 120, alignment: .leading)
                                    .onAppear {
                                        if foundItems.isLast(item) {
                                            needForFurtherLoad = true
                                        }
                                    }.onTapGesture {
                                        selectedOMDBMovie = item
                                    }
                            }.onAppear {
                                if let selectedMovie = selectedOMDBMovie {
                                    withAnimation {
                                        scrollProxy.scrollTo(selectedMovie, anchor: .center)
                                    }
                                }
                                selectedOMDBMovie = nil
                            }
                        }
                        if movieSearchStatus == .loading {
                            ProgressView("", value: progressLoad, total: 100)
                                .frame(width: geometry.size.width, height: 3, alignment: .center)
                        }
                        
                        if movieSearchStatus == .endOfSearch {
                            Text("End of search").frame(width: geometry.size.width, height: 30, alignment: .center)
                        }
                    }
                }
            default:
                EmptyView()
            }
        }
    }
}

struct MoviesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesSearchRenderView(
            accentColor: .constant(.red),
            searchQuery: .constant("SomeText"),
            movieSearchStatus: .constant(.initial),
            foundItems: .constant([]),
            needForFurtherLoad: .constant(false),
            selectedOMDBMovie: .constant(nil),
            progressLoad: .constant(0))
    }
}
