//  NavigationType.swift
//  Created by Dmitry Samartcev on 25.03.2021.

import Foundation
/// Determines type of navigation - direction of movement along stack
public enum NavigationType {
    /// Move forward on stack
    case push
    /// Move backward on stack
    case pop
}
