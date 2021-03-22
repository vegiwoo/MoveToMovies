//
//  MovieDetailScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 06.03.2021.
//

import SwiftUI
import TmdbAPI
import MapKit
import UIControls

extension ProductionCountry: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

struct MovieDetailScreen: View, SizeClassAdjustable {

    @EnvironmentObject var appState: AppState
    
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var movie: Movie
    @State var averageColor: UIColor?
    
    @State var isMapPresented: Bool = false

    var body: some View {
        Text("").onAppear {
            averageColor = appState.appViewModel.getAverageColorForMovie(id: movie.id!)
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: Movie(title: "Some movie"), isMapPresented: false)
    }
}
