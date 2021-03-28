//
//  MovieToMoviesViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import TmdbAPI
import Combine
import MapKit

struct ProductionCountryDTO {
    let key: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

final class AppViewModel: ObservableObject {
    
    let apikey = ""
    
    @Published var genres: [Genre] = .init()
    private var popularMoviesList: [MovieListResultObject] = .init()
    @Published var popularMovies: [Movie] = .init()
    var posters: [Int: UIImage] = .init()
    var productionCountries: [ProductionCountryDTO] = .init()
    
    let queue = DispatchQueue.global(qos: .utility)
    
    var subscriber: AnyCancellable?
    
    init() {}
}

extension AppViewModel {
    
    func getRandomMovie() -> Movie? {
        guard popularMovies.count > 0,
              let randomMovie = popularMovies.randomElement()
        else { return nil }
        
        return randomMovie
    }
    
    func getMovie(id: Int) -> Movie? {
        return popularMovies.first(where: {$0.id == id})
    }
    
    func getGernesString(for movie: Movie) -> String? {
        var resultString: String = .init()
        if let movieGernes = movie.genres, movieGernes.count > 0 {
            for (index,value) in movieGernes.enumerated() {
                guard let gerne = value.name else { continue }
                if index != movieGernes.endIndex - 1 {
                    resultString.append("\(gerne), ")
                    if index == 2 { resultString.append("\n") }
                } else {
                    resultString.append("\(gerne)")
                }
            }
        }
        return resultString
    }
    
    func getYearForMovie(id: Int) -> String? {
        guard let movie = getMovie(id: id),
              let releaseDate = movie.releaseDate
        else { return nil}
        
        return releaseDate.components(separatedBy: "-").first
    }
    
    func getPosterForMovie(id: Int) -> UIImage? {
        posters[id]
    }
    
    func getAverageColorForMovie(id: Int) -> UIColor? {
        posters[id]?.averageColor
    }
    
    func getProductionCountry(by key: String) -> ProductionCountryDTO? {
        productionCountries.first(where: {$0.key == key})
    }
}


extension Genre: Identifiable {}
extension Movie: Identifiable {}
