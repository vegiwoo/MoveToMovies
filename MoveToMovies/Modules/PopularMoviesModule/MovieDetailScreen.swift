//
//  MovieDetailScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 06.03.2021.
//

import SwiftUI
import TmdbAPI
import MapKit

extension ProductionCountry: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

struct MovieDetailScreen: View {

    @EnvironmentObject var appState: AppState
    
    var movie: Movie
    @State var fullMovieInfo: Movie?
    
    @State var isMapPresented: Bool
    @State private var centerCoordinate: CLLocationCoordinate2D = .init(latitude: 43.585472, longitude: 39.723089)
    
    @State var mapItem: MKMapItem? {
        didSet {
            if mapItem != nil {
                centerCoordinate = CLLocationCoordinate2D (latitude: mapItem!.placemark.coordinate.latitude, longitude: mapItem!.placemark.coordinate.longitude)
                isMapPresented = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if let countries = fullMovieInfo?.productionCountries {
                HStack {
                    ForEach(0..<countries.count) {index in
                        Button(action: {
                            searchPlace(countries[index].name!)
                        }, label: {
                            Text(countries[index].iso31661!)
                        })
                        .frame(width: 35, height: 35, alignment: .center)
                        .background(Color.green).foregroundColor(.white).cornerRadius(10)
                    }
                }
            } else {
               Text("")
            }
        }.onAppear {
            // TODO: ...
        }.sheet(isPresented: $isMapPresented) {
            VStack {
                ZStack {
                    MapView(centerCoordinate: $centerCoordinate)
                    Circle()
                            .fill(Color.blue)
                            .opacity(0.3)
                            .frame(width: 32, height: 32)
                }
                Button(action: {isMapPresented.toggle()}, label: {
                    Image(systemName: "xmark").foregroundColor(.black).font(.title)
                })
            }
        }
    }
    
    func searchPlace(_ place: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = place
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            mapItem = response.mapItems.first
        }
    }
    
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: Movie(title: "Some movie"), isMapPresented: false)
    }
}
