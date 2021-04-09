//
//  AppEnvironment.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import Architecture
import Networking

final class AppEnvironment: Singletonable {
    
    @Resolvable
    var networkProvider: NetworkProvider
    @Resolvable
    var coreDataProvider: CoreDataProvider
    
    init(container: IContainer, args: ()) {}
}
