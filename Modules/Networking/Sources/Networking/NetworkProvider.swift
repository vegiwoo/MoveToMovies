//  Network.swift
//  Created by Dmitry Samartcev on 31.03.2021.

import Foundation
import Combine
import Architecture
import OmdbAPI

public class NetworkProvider: Singletonable {
    
    private var session: URLSession = URLSession.shared
    private var jsonDecoder: JSONDecoder = .init()
    
    public required init(container: IContainer, args: Void) { }
    
    private lazy var apiRequestQueue: DispatchQueue = {
        return DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).apiRequestQueue" : "apiRequestQueue", qos: .utility)
    }()
    
    // MARK: Common Methods
    public func loadData(for items: [String: String?]) -> AnyPublisher<[(String, Data?)], Never> {
        var futures: [AnyPublisher<(String, Data?), Never>] = []
        
        for item in items {
            guard let urlString = item.value,
                  let url = URL(string: urlString) else {
                continue
            }
            let future = Future<(String, Data?), Never> { promise in
                URLSession.shared.dataTask(with: url) {data, response, error in
                    if let data = data {
                        promise(.success((item.key, data)))
                    }
                }.resume()
            }
            futures.append(future.eraseToAnyPublisher())
        }

        return futures.dropFirst().reduce(into: AnyPublisher(futures[0].map{[$0]})) {
            res, just in
            res = res.zip(just) {
                i1, i2 -> [(String,Data?)] in
                return i1 + [i2]
            }
            .eraseToAnyPublisher()
        }
    }

    // MARK: OmdbAPI
    public func loadMovieRequest(query: String, page: Int) -> AnyPublisher<MovieOmdbapiObjectResponse, Never>? {

        let builder = OmdbAPI.DefaultAPI.rootGetWithRequestBuilder(s: query, apikey: API.omdbApiKey.description, page: page)
        
        guard let url = URL(string: builder.URLString) else {
            return nil
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieOmdbapiObjectResponse.self, decoder: jsonDecoder)
            .replaceError(with: MovieOmdbapiObjectResponse(search: [], totalResults: "", response: ""))
            .eraseToAnyPublisher()
    }
}

public struct MovieOmdbapiObjectResponse: Codable {
    public let search: [MovieOmdbapiObject]
    public let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

public struct ImageDataObjectResponse: Codable {
    public let data: Data?
    public let imdbID: String

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case imdbID = "ImdbID"
    }
}

public extension NetworkProvider {
    enum API: CustomStringConvertible {
        case tmdbApiKey
        case tmdbImagesPath
        case omdbApiKey
        public var description: String {
            switch self {
            case .tmdbApiKey:
                return "2e6b2f25124ca8304e9b74fb99176e96"
            case .tmdbImagesPath:
                return "https://image.tmdb.org/t/p/"
            case .omdbApiKey:
                return "90001c5d"
            }
        }
    }
}
