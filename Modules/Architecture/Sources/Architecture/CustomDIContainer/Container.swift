//  Container.swift
//  Created by Dmitry Samartcev on 31.03.2021.

import Foundation

public class Container {
    private var singletones: [ObjectIdentifier : AnyObject] = [:]
    
    public init() {}
    
    public func makeInstance<T:IResolvable>(args: T.Arguments) -> T {
        return T(container: self, args: args)
    }
}

extension Container: IContainer {
    public func resolve<T>(args: T.Arguments) -> T where T : IResolvable {
        switch T.instanceScope {
        case .perRequest:
            return makeInstance(args: args)
        case .singletone:
            let key = ObjectIdentifier(T.self)
            if let cashed = singletones[key], let instance = cashed as? T {
                return instance
            } else {
                let instance: T = makeInstance(args: args)
                singletones[key] = instance
                return instance
            }
        }
    }
}
