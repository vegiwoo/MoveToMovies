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
    
    let apikey = API.apiKey.description
    
    @Published var genres: [Genre] = .init()
    private var popularMoviesList: [MovieListResultObject] = .init()
    @Published var popularMovies: [Movie] = .init()
    var posters: [Int: UIImage] = .init()
    var productionCountries: [ProductionCountryDTO] = .init()
    
    let queue = DispatchQueue.global(qos: .utility)
    
    var subscriber: AnyCancellable?
    
    init() {
        getGenres()
        getPopularMovies()
    }
}

extension AppViewModel {
    private func getGenres() {
        queue.async(flags: .barrier) {
            self.genres.removeAll()
            TmdbAPI.DefaultAPI.genreMovieListGet(apiKey: self.apikey) { (response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                } else {
                    if let responseGernes = response?.genres {
                        self.genres = responseGernes
                    }
                }
            }
        }
    }
    
    private func getPopularMovies() {
        
        var completion: Bool = false {
            didSet {
                if completion {
                    self.getMoviesInfo()
                    self.getPosters()
                }
            }
        }
        
        queue.async(flags: .barrier) {
            self.popularMoviesList.removeAll()
            TmdbAPI.DefaultAPI.moviePopularGet(apiKey: self.apikey) { (response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                } else {
                    if let popularMovies = response?.results {
                        self.popularMoviesList = popularMovies
                    }
                }
                completion = true
            }
        }
    }
    
    private func getMoviesInfo() {
        
        popularMoviesList.forEach {
            if let movieId = $0.id {
                queue.async(flags: .barrier) {
                    TmdbAPI.DefaultAPI.movieMovieIdGet(movieId: movieId, apiKey: self.apikey) { (movie, error) in
                        if let error = error {
                            DispatchQueue.main.async {
                                print(error.localizedDescription)
                            }
                        } else {
                            if let movie = movie {
                                self.popularMovies.append(movie)
                                if self.popularMoviesList.count == self.popularMovies.count {
                                    self.getContries()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func getPoster(for movieId: Int, from posterPath: String, posterSize: PosterSizes) {
        
        let string = "https://image.tmdb.org/t/p/\(posterSize)\(posterPath)"
        guard let url = URL(string: string) else { return }
        
        self.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            guard let poster = UIImage(data: data) else { return }
            self.posters.updateValue(poster, forKey: movieId)
        }
        
    }
    
    private func getPosters() {
        guard popularMoviesList.count > 0 else { return }
        posters.removeAll()
        queue.async(flags: .barrier) {
            self.popularMoviesList.forEach {
                if let id = $0.id, let posterPath = $0.posterPath {
                    self.getPoster(for: id, from: posterPath, posterSize: .w185)
                }
            }
        }
    }
    
    private func getContries() {
        popularMovies.compactMap{$0.productionCountries}.forEach{countries in
            countries.forEach{country in
                
                if let iso31661 = country.iso31661, let name = country.name,
                   !productionCountries.contains(where: {$0.key == iso31661}) {
                    
                    queue.async(flags: .barrier) {
                        
                        let searchRequest = MKLocalSearch.Request()
                        searchRequest.naturalLanguageQuery = country.name
                        let search = MKLocalSearch(request: searchRequest)
                        
                        search.start { (response, error)  in
                            guard let response = response else {
                                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                                return
                            }
                            
                            if let coordinate = response.mapItems.first?.placemark.coordinate{
                                self.productionCountries.append(ProductionCountryDTO(key: iso31661, name: name, coordinate: coordinate))
                            }
                        }
                    }
                }
            }
        }
    }
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

enum PosterSizes {
    case w92, w154, w185, w342, w500, w780, original
}
