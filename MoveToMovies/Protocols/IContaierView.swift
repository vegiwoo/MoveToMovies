//
//  IContaierView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.04.2021.
//

import Foundation
import Navigation

protocol IContaierView {
    var appStore: AppStore<AppState, AppAction, AppEnvironment> { get }
    var navCoordinator: NavCoordinatorViewModel { get }
}
