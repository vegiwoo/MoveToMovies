//  MovieView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 28.03.2021.

import SwiftUI
import Navigation
import OmdbAPI

struct MovieView: View {
    
    @EnvironmentObject var vm: MovieSearchScreenViewModel
    
    private var popularMovie: MovieItem?
    private var searchMovie: (MovieOmdbapiObject, Data?)?
    
    
    private var actualColor: Color
    
    @State var gernesColumns: [GridItem] = .init()
    @State var companiesColumns: [GridItem] = .init()
    
    init(popularMovie: MovieItem? = nil, searchMovie: (MovieOmdbapiObject, Data?)? = nil, actualColor: Color) {
        if let popularMovie = popularMovie {
            self.popularMovie = popularMovie
        }
        if let searchMovie = searchMovie {
            self.searchMovie = searchMovie
        }
        self.actualColor = actualColor
    }
    
    var body: some View {
        VStack (spacing: 16) {
            if let popularMovie = popularMovie {
                if let tagline = popularMovie.tagline {
                    Text(tagline).font(Font.system(.caption, design: Font.Design.monospaced))
                }
                
                if let originalTitle = popularMovie.originalTitle {
                    Text("Original title\n" + "'\(originalTitle)'")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if let genres = popularMovie.genres?.allObjects as? Array<GenreItem> {
                    LazyVGrid(columns: genres.count.isMultiple(of: 2) ? Array(repeating: GridItem(.flexible()), count: 2) : gernesColumns, alignment: .center, spacing: 10, content: {
                        ForEach(0..<genres.count) {index in
                            Text("\(genres[index].name ?? "")")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    })
                }
                
                if let voteAverange = popularMovie.voteAverage, let voteCount = popularMovie.voteCount {
                    Text("Rating \(voteAverange, specifier: "%.1f") by \(voteCount) votes")
                        .foregroundColor(voteAverange > 6 ? .green : .red)
                }
                
                if let overView = popularMovie.overview {
                    Text(overView)
                }

                if let companies = popularMovie.companies?.allObjects as? Array<ProductionCompanyItem> {
                    LazyVGrid(columns: companiesColumns, alignment: .center, spacing: 10, content: {
                        ForEach(0..<companies.count) {index in
                            Text("\(companies[index].name ?? "")")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    })
                }
                
                VStack (alignment: .leading, spacing: 10) {
                    if let budget = popularMovie.budget, budget > 0 {
                        Text("Budget $\(budget)")
                            .frame(maxWidth: .infinity)
                            .frame(alignment: .leading)
                    }
                    
                    if let revenue = popularMovie.revenue, revenue > 0 {
                        Text("Revenue $\(revenue)")
                            .frame(maxWidth: .infinity)
                    }
                }
                NavPushButton(destination: PosterAndBackDropScreen(posterData: popularMovie.poster?.blob, backdropData: popularMovie.backdrop?.blob).environmentObject(vm)) {
                    Text("Poster && BackDrop").foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .onAppear {
            setCountColumnsForItems()
        }
    }
    
    private func setCountColumnsForItems() {
        if let popularMovie = popularMovie {
            if let companiesCount = popularMovie.companies?.count {
                if companiesCount == 1 {
                    companiesColumns = Array(repeating: GridItem(.flexible()), count: 1)
                } else {
                    companiesColumns = Array(repeating: GridItem(.flexible()), count: 2)
                }
            }
            
            if let genresCount = popularMovie.genres?.count {
                if genresCount == 1 {
                    gernesColumns = Array(repeating: GridItem(.flexible()), count: 1)
                } else {
                    gernesColumns = Array(repeating: GridItem(.flexible()), count: 2)
                }
            }
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        
       let movie = AppState.dataStoreService.getRendomMovieItem()
        MovieView(popularMovie: movie ?? MovieItem(), actualColor: .blue).environmentObject(movie ?? MovieItem())
    }
}
