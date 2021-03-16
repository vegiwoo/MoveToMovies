//
//  UIImage + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 15.03.2021.
//

import UIKit

extension UIImage {
    var toData: Data? {
        return pngData()
    }
}
