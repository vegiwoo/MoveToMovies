//
//  AppStore.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import SwiftUI
import Combine
import Networking

final class AppStore<State, Action, Environment>: ObservableObject {
   
    @Published private(set) var state: State
    
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(initialState: State,
         reducer: @escaping Reducer<State, Action, Environment>,
         environment: Environment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: Action) {
          let effect = reducer(&state, action, environment)
          
          effect
              .receive(on: DispatchQueue.main)
              .sink(receiveValue: send)
              .store(in: &cancellables)
    }
}
