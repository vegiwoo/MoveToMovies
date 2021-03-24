//
//  PopularMovieDTO.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 20.03.2021.
//

import SwiftUI
import UIControls

public protocol MovieCellModelProtocol {
    var image: UIImage? { get set }
    var title: String { get set }
    var subtitle01: String? { get set }
    var subtitle02: String { get set }
    var rightView: AnyView? { get set }
}

public struct PopularMovieDTO: MovieCellModelProtocol {
    
    public var image: UIImage?
    public var title: String
    public var subtitle01: String?
    public var subtitle02: String
    public var rightView: AnyView?
    
    public let df = DateFormatter()

    public init (fromMovieItem movie: MovieItem) {
        if let blob = movie.poster?.blob {
            self.image = UIImage(data: blob)
        } else {
            self.image = nil
        }
        self.title = movie.title ?? ""
        self.subtitle01 = ""

        if let genres = movie.genres, let array = genres.allObjects as? [GenreItem] {
            self.subtitle01 = PopularMovieDTO.setGenreString(by: array)
        }
        
        self.subtitle02 = ""
        if let releaseDate = movie.releaseDate{
            df.dateFormat = "dd.MM.yyyy"
            self.subtitle02  = df.string(from: releaseDate)
        }


        self.rightView =
            AnyView(
                ZStack {
                    Circle().stroke()
                    Text("\(movie.voteAverage, specifier: "%.1f")").font(Font.system(size: 14))
            }
                .padding(.trailing)
                .foregroundColor(.secondary)
                .id("movieCell-rightViewZStack-\(UUID().uuidString)")
            )
    }

    public init(imageBlob: Data? = nil,title: String, subtitle01: String? = nil, subtitle02: String, rightView: AnyView? = nil) {
        self.image = imageBlob != nil ? UIImage(data: imageBlob!) : nil
        self.title = title
        self.subtitle01 = subtitle01
        self.subtitle02 = subtitle02
        self.rightView = rightView
    }
    
    private static func setGenreString(by items:  [GenreItem]) -> String? {
        var resultString = ""
        for (index,value) in items.enumerated() {
            if let name = value.name {
                if index != items.endIndex - 1 {
                    resultString.append("\(name), ")
                    if index == 2 { resultString.append("\n")}
                    
                } else {
                    resultString.append(name)
                }
            }
        }
        return resultString
        
    }
}
