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

struct MoviesRenderView: View {
    
    @EnvironmentObject private var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let title: String
    let accentColor: UIColor
    
    private var segmentes: [String] = ["Search", "Popular"]
    @Binding var selectedIndexSegmentControl: Int
    @Binding var selectedTMDBMovie: MovieItem?
    @Binding var gotoDetailedView: Bool
    
    @State var gotoDetail: Bool = false
    
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: false) ]
    ) var popularMovies: FetchedResults<MovieItem>
    
    init(title: String,
         accentColor: UIColor,
         selectedIndexSegmentControl: Binding<Int>,
         selectedTMDBMovie: Binding<MovieItem?>,
         gotoDetailedView: Binding<Bool>
    ) {
        self.title = title
        self.accentColor = accentColor
        self._selectedIndexSegmentControl = selectedIndexSegmentControl
        self._selectedTMDBMovie = selectedTMDBMovie
        self._gotoDetailedView = gotoDetailedView
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
                    MoviesSearchContainerView().environmentObject(appStore)
        
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
                        }
                        .transition(.opacity)
                        .onAppear {
                            if !gotoDetailedView, let selectedMovie = selectedTMDBMovie {
                                DispatchQueue.main.async {
                                    withAnimation(Animation.easeInOut(duration: 2.0)) {
                                        scrollProxy.scrollTo(selectedMovie, anchor: .center)
                                        selectedTMDBMovie = nil
                                    }
                                }
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
        MoviesRenderView(title: "Some title",
                              accentColor: .brown,
                              selectedIndexSegmentControl: .constant(0),
                              selectedTMDBMovie: .constant(nil),
                              gotoDetailedView: .constant(false)
                    )
    }
}
