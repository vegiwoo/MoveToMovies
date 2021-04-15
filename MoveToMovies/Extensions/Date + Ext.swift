//
//  Date + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//
import Foundation

extension Date {
    public func toString(with format: String) -> String? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = format
        return df.string(from: self)
    }
}

