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

extension AppStore {
    func binding<Value>(for keyPath: KeyPath<State, Value>,
                        toAction: @escaping (Value) -> Action) -> Binding<Value> {
        Binding<Value>(
            get: {self.state[keyPath: keyPath]},
            set: {self.send(toAction($0))}
        )
    }
    
    func binding<Value>(for keyPath: KeyPath<State, Value>) -> Binding<Value> {
        Binding<Value>(
            get: {
                self.state[keyPath: keyPath]},
            set: {
                print($0)
                self.state = $0 as! State
            }
        )
    }
}

/*
 let binding = Binding(
             get: { self.selection },
             set: { self.selection = $0 }
         )
 
 
 */
