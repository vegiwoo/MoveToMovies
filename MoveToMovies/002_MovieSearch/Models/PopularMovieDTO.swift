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
        
        if let genresSet = movie.genres,
           let genres = genresSet.allObjects as? [GenreItem] {
            for (index,value) in genres.enumerated() {
                if index != genres.endIndex - 1 {
                    self.subtitle01!.append("\(String(describing: value.name)), ")
                    if index == 2 { self.subtitle01!.append("\n")
                    } else {
                        self.subtitle01!.append("\(String(describing: value.name))")
                    }
                    
                }
            }
        }
        
        self.subtitle02 = movie.releaseDate != nil ? df.string(from: movie.releaseDate!) : ""

        self.rightView =
            AnyView(
                ZStack {
                    Circle().stroke()
                    Text("\(movie.voteAverage, specifier: "%.1f")").font(Font.system(size: 18))
            }
                .padding(.trailing)
                .foregroundColor(.secondary)
            )
    }

    public init(imageBlob: Data? = nil,title: String, subtitle01: String? = nil, subtitle02: String, rightView: AnyView? = nil) {
        self.image = imageBlob != nil ? UIImage(data: imageBlob!) : nil
        self.title = title
        self.subtitle01 = subtitle01
        self.subtitle02 = subtitle02
        self.rightView = rightView
    }
}
