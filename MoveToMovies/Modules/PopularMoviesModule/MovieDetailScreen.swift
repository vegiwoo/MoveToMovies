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
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var movie: Movie
    @State var averageColor: UIColor?
    
    @State var isMapPresented: Bool = false
    @State private var centerCoordinate: CLLocationCoordinate2D = .init(latitude: 43.585472, longitude: 39.723089)
    
    @State private var countries: [ProductionCountryDTO] = .init()
    
    private func unwind() {
        appState.isQuickLink = false
        appState.selectionTab = .popularMoviesScreen
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white,averageColor != nil ? Color(averageColor!) : .white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges: [.bottom, .trailing])
                VStack(spacing: geometry.size.width / 40) {
                    BackButton(width: geometry.size.width - 32, text: "Back", color: .blue, action: unwind)
                    Text(movie.title!).font(.largeTitle).lineLimit(3).multilineTextAlignment(.center)
                    if countries.count > 0 {
                        HStack {
                            ForEach(0..<countries.count) {index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).stroke()
                                    Text(countries[index].key)
                                }
                                .frame(width: geometry.size.width / 10, height: geometry.size.width / 10, alignment: .center)
                                .foregroundColor(Color.blue)
                                .background(Color.clear)
                                .onTapGesture {
                                    centerCoordinate = countries[index].coordinate
                                    isMapPresented = true
                                }
                                
                            }
                        }
                    }
                    EmptyView()
                }.frame(width: geometry.size.width - 32, height: geometry.size.height - 52, alignment: .top)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            averageColor = appState.appViewModel.getAverageColorForMovie(id: movie.id!)
            
            movie.productionCountries?.forEach{ productionCountry in
                if let key = productionCountry.iso31661,
                   let country = appState.appViewModel.getProductionCountry(by: key) {
                    countries.append(country)
                }
            }
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
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(movie: Movie(title: "Some movie"), isMapPresented: false)
    }
}
