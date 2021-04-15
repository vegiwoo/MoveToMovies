//
//  TmdbMovieInfoView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//

import SwiftUI

struct TmdbMovieInfoView: View {
    
    @State var gernesColumns: [GridItem] = .init()
    @State var companiesColumns: [GridItem] = .init()
    
    let selectedTMDBMovie: MovieItem
    
    var body: some View {
        VStack(spacing: 16) {
            if let tagline = selectedTMDBMovie.tagline, !tagline.isEmpty {
                VStack {
                    Text("Slogan").headerStyle()
                    Text("'\(tagline)'").infoStyle()
                }
            }
            if let originalTitle = selectedTMDBMovie.originalTitle, !originalTitle.isEmpty {
                VStack {
                    Text("Original Title").headerStyle()
                    Text(originalTitle).infoStyle()
                }
            }
            if let genresSet = selectedTMDBMovie.genres,
               let genresArray = genresSet.allObjects as? [GenreItem] {
                VStack {
                    Text("Genres").headerStyle()
                    LazyHGrid(rows: gernesColumns, spacing: 10) {
                        ForEach(genresArray, id: \.self) {item in
                            if let name = item.name {
                                Text(name).infoStyle()
                            }
                        }
                    }
                }
            }
            if let overview = selectedTMDBMovie.overview {
                VStack {
                    Text("Overview").headerStyle()
                    Text(overview).infoStyle().frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            if let voteCount = selectedTMDBMovie.voteCount,
               let voteAverage = selectedTMDBMovie.voteAverage {
                VStack {
                    Text("Rating").headerStyle()
                    Text("rated \(voteAverage, specifier: "%.1f") based on \(voteCount) votes").infoStyle()
                }
            }
            if let companiesSet = selectedTMDBMovie.companies,
               let companiesArray = companiesSet.allObjects as? [ProductionCompanyItem],
               !companiesArray.isEmpty {
                VStack {
                    Text("Production companies").headerStyle()
                    LazyHGrid(rows: companiesColumns, spacing: 10) {
                        ForEach(companiesArray, id: \.self) {item in
                            if let name = item.name {
                                Text(name).infoStyle()
                            }
                        }
                    }
                }
            }
            if let releaseDate = selectedTMDBMovie.releaseDate, let dateString = releaseDate.toString(with: "dd.MM.yyyy") {
                VStack {
                    Text("Release date").headerStyle()
                    Text("\(dateString)")
                }
            }
            
        }
        .onAppear {
            setCountColumnsForItems()
            
        }
    }
    
    private func setCountColumnsForItems() {
        if let genresCount = selectedTMDBMovie.genres?.count {
            if genresCount == 1 {
                gernesColumns = Array(repeating: GridItem(.flexible()), count: 1)
            } else {
                gernesColumns = Array(repeating: GridItem(.flexible()), count: 2)
            }
        }
        
        if let companiesCount = selectedTMDBMovie.companies?.count {
            if companiesCount == 1 {
                companiesColumns = Array(repeating: GridItem(.flexible()), count: 1)
            } else {
                companiesColumns = Array(repeating: GridItem(.flexible()), count: 2)
            }
        }
    }

}
