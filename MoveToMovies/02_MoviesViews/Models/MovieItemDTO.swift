//
//  ModelItemDTO.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 12.04.2021.
//

import Foundation

public struct MovieItemDTO {
    
    public var title: String
    public var originalTitle: String
    public var tagLine: String
    public var genres: [String]
    public var releaseDate: String
    public var overview: String
    public var countries: [String]
    public var companies: [String]
    public var voteAverage: String
    public var poster: Data?
    public var backdrop: Data?
    
    public init(_ movieItem: MovieItem) {
        self.title = movieItem.title != nil ? movieItem.title! : ""
        self.originalTitle = movieItem.originalTitle != nil ? movieItem.originalTitle! : ""
        self.tagLine = movieItem.tagline != nil ? movieItem.tagline! : ""
        
        self.genres = []
        if let genres = movieItem.genres,
           let array = genres.allObjects as? [GenreItem] {
            self.genres = array.map{$0.name!}
        }
        
        if let releaseDate = movieItem.releaseDate {
            self.releaseDate = MovieItemDTO.setDateString(for: releaseDate) ?? ""
        } else {
            self.releaseDate = ""
        }
        
        self.overview = movieItem.overview != nil ? movieItem.overview! : ""
        
        self.countries = []
        if let countries = movieItem.countries, let array = countries.allObjects as? [ProductionCountryItem] {
            self.countries = array.map{$0.iso31661!}
        }
        
        self.companies = []
        if let companies = movieItem.companies, let array = companies.allObjects as? [ProductionCompanyItem] {
            self.companies = array.map{$0.name!}
        }
        
        self.voteAverage = String(format: "%.1f", movieItem.voteAverage)
        self.poster = movieItem.poster != nil ? movieItem.poster!.blob : nil
        self.backdrop = movieItem.backdrop != nil ? movieItem.backdrop!.blob : nil
    }
    
    

    
    private static func setDateString(for date: Date) -> String? {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df.string(from: date)
    }
}
