//
//  MovieInfoRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.04.2021.
//

import SwiftUI
import OmdbAPI

struct MovieInfoRenderView: View {
    
    @Binding var selectedOMDBMovie: MovieOmdbapiObject?
    @Binding var searchOMDBMoviePoster: Data?
    @Binding var selectedTMDBMovie: MovieItem?
    
    @State var gernesColumns: [GridItem] = .init()
    @State var companiesColumns: [GridItem] = .init()
    
    var body: some View {
        Group {
            if let selectedOMDBMovie = selectedOMDBMovie {
                VStack (spacing: 16) {
                    if let year = selectedOMDBMovie.year {
                        Text("Year: \(year)")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    if let type = selectedOMDBMovie.type {
                        Text("Type: \(type.rawValue)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            } /*else if let selectedTMDBMovie = selectedTMDBMovie {
                
                
                
                
                
            }*/
        }.padding(.horizontal)
            .padding(.top, 16)
            .onAppear {
                setCountColumnsForItems()
            }
        }
    
    private func setCountColumnsForItems() {
        if let popularMovie = selectedTMDBMovie {
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

struct MovieInfoRenderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieInfoRenderView(selectedOMDBMovie: .constant(nil), searchOMDBMoviePoster: .constant(nil), selectedTMDBMovie: .constant(nil))
    }
}
