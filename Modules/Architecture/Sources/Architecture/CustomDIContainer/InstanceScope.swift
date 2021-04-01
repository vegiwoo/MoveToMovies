//  InstanceScope.swift
//  Created by Dmitry Samartcev on 31.03.2021.

import Foundation

/// Responsible for the scope in which the object instance will exist
public enum InstanceScope {
    case perRequest // A new instance will be created for each call
    case singletone // Instance is created once on first call
}
