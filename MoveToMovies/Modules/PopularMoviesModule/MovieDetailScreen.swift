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

struct MovieDetailScreen: View, SizeClassAdjustable {

    @EnvironmentObject var appState: AppState
    
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var movie: Movie
    @State var averageColor: UIColor?
    
    @State var isMapPresented: Bool = false
//    @State private var centerCoordinate: CLLocationCoordinate2D = .init(latitude: 43.585472, longitude: 39.723089)
    
//    @State var mapItem: MKMapItem? {
//        didSet {
//            if mapItem != nil {
//                centerCoordinate = CLLocationCoordinate2D (latitude: mapItem!.placemark.coordinate.latitude, longitude: mapItem!.placemark.coordinate.longitude)
//                isMapPresented = true
//            }
//        }
//    }
    
    private func unwind() {
        appState.isQuickLink = false
        appState.selectionTab = .popularMoviesScreen
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white,averageColor != nil ? Color(averageColor!) : .white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges: [.bottom, .trailing])
                VStack {
                    BackButton(width: geometry.size.width - 32, text: "Back", color: .blue, action: unwind)
                    Text(movie.title!).font(.largeTitle).lineLimit(3).multilineTextAlignment(.center)
                    EmptyView()
                }.frame(width: geometry.size.width - 32, height: geometry.size.height - 52, alignment: .top)
            }
            .ignoresSafeArea()
        }

//NavigationView {
//
//            if let countries = fullMovieInfo?.productionCountries {
//                HStack {
//                    ForEach(0..<countries.count) {index in
//                        Button(action: {
//                            searchPlace(countries[index].name!)
//                        }, label: {
//                            Text(countries[index].iso31661!)
//                        })
//                        .frame(width: 35, height: 35, alignment: .center)
//                        .background(Color.green).foregroundColor(.white).cornerRadius(10)
//                    }
//                }
//            } else {
//               Text("")
//            }
        .onAppear {
            averageColor = appState.appViewModel.getAverageColorForMovie(id: movie.id!)
        }
//        }.sheet(isPresented: $isMapPresented) {
//            VStack {
//                ZStack {
//                    MapView(centerCoordinate: $centerCoordinate)
//                    Circle()
//                            .fill(Color.blue)
//                            .opacity(0.3)
//                            .frame(width: 32, height: 32)
//                }
//                Button(action: {isMapPresented.toggle()}, label: {
//                    Image(systemName: "xmark").foregroundColor(.black).font(.title)
//                })
//            }
//        }
    }
    
//    func searchPlace(_ place: String) {
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = place
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { response, error in
//            guard let response = response else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error").")
//                return
//            }
//            //mapItem = response.mapItems.first
//        }
//    }
    
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: Movie(title: "Some movie"), isMapPresented: false)
    }
}
