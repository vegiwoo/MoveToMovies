//
//  MovieCell.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 22.03.2021.
//

import SwiftUI
import UIControls

public struct MovieCell: View, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    public var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    public var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var image: UIImage?
    var title: String
    var subtitle01: String?
    var subtitle02: String
    var rightView: AnyView?
    
    init(model: MovieCellModelProtocol) {
        self.image = model.image
        self.title = model.title
        self.subtitle01 = model.subtitle01
        self.subtitle02 = model.subtitle02
        self.rightView = model.rightView
    }
    
    public var body: some View {
        GeometryReader {geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width, height: geometry.size.height / 8, alignment: .leading)
                    .background(Color.gray)
                    .opacity(0.1)
                HStack {
                    // Poster
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .smallPosterFrame(geometrySize: geometry.size)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(.gray)
                            .smallPosterFrame(geometrySize: geometry.size)
                    }
                    // Titles
                    VStack(alignment: .leading, spacing: geometry.size.width / 65) {
                        // EmptyView
                        Text("")
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                        // title
                        Text(title)
                            .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.bold)
                            .lineLimit(2)
                        // subtitle01
                        if let subtitle01 = subtitle01 {
                            Text(subtitle01)
                                .font(Font.system(size: isPad ? 24 : isPadOrLandscapeMax ? 18 : 14)).fontWeight(.regular)
                                .lineLimit(2)
                        }
                        // subtitle02
                        if let subtitle02 = subtitle02 {
                            Text(subtitle02)
                                .font(Font.system(size: isPad ? 20 : isPadOrLandscapeMax ? 16 : 12)).fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }.padding([.leading], 10)
                    
                    // Right view
                    if let rightView = self.rightView {
                        rightView
                            .frame(width: isPad ? geometry.size.width / 12 : isPadOrLandscapeMax ? geometry.size.width / 10 : geometry.size.width / 8)
                            .padding(.trailing)
                            .foregroundColor(.secondary)
                    }
                    
                    
                    //                    ZStack {
                    //                        Circle().stroke()
                    //                        if let popularity = movie.voteAverage {
                    //                            Text("\(popularity, specifier: "%.1f")").font(Font.system(size: 18))
                    //                        }
                    //                    }
                    
                }
            }
        }
    }
}

struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(model: DummyCell())
    }
}

struct DummyCell: MovieCellModelProtocol {
    var image: UIImage? = UIImage(named: "dummyImage500x500")
    var title: String = "Some title"
    var subtitle01: String? = "Comedy, Drama, Adventure"
    var subtitle02: String = "1980"
    var rightView: AnyView? = AnyView(ZStack{Circle().stroke();Text("10.0")})
}
