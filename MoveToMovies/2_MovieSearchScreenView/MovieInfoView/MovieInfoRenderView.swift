//
//  MovieInfoRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.04.2021.
//

import SwiftUI
import OmdbAPI
import Navigation

struct MovieInfoRenderView: View {
    
    @Binding var selectedOMDBMovie: MovieOmdbapiObject?
    @Binding var searchOMDBMoviePoster: Data?
    @Binding var selectedTMDBMovie: MovieItem?
    
    var body: some View {
        Group {
            if let item = selectedOMDBMovie {
                OmbdMovieInfoView(selectedOMDBMovie: item)
            } else if let item = selectedTMDBMovie {
                VStack {
                    TmdbMovieInfoView(selectedTMDBMovie: item)
                    PushView(destination: PosterAndBackdropContainerView()) {
                        ZStack {
                            Group {
                                if let selectedTMDBMovie = selectedTMDBMovie {
                                    if let backdropData = selectedTMDBMovie.backdrop?.blob,
                                       let uiImage = UIImage(data: backdropData) {
                                        Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 50, alignment: .center)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        
                                    
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .background(Color.gray)
                                            .frame(width: 200, height: 50, alignment: .center)
                                    }
                                }
                            }
                            .opacity(0.6)
                            Text("Poster and Backdrop").foregroundColor(.white).fontWeight(.bold)
                        }
                    }
                }
                
                
                
                
            }
        }.padding(.horizontal)
            .padding(.top, 16)
        }
    
    private struct OmbdMovieInfoView: View {
        
        let selectedOMDBMovie: MovieOmdbapiObject
        
        var body: some View {
            VStack (spacing: 16) {
                if let originalTitle = selectedOMDBMovie.title {
                    VStack {
                        Text("Original Title").headerStyle()
                        Text(originalTitle).infoStyle()
                    }
                }
                if let year = selectedOMDBMovie.year {
                    VStack {
                        Text("Year").headerStyle()
                        Text("\(year)").infoStyle()
                    }
                }
                if let type = selectedOMDBMovie.type {
                    VStack {
                        Text("Type").headerStyle()
                        Text("\(type.rawValue)").infoStyle()
                    }
                }
                Spacer()
            }
        }
    }
}

struct MovieInfoRenderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieInfoRenderView(selectedOMDBMovie: .constant(nil), searchOMDBMoviePoster: .constant(nil), selectedTMDBMovie: .constant(nil))
    }
}


