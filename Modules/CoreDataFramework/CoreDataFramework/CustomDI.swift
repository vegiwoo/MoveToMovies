//
//  CustomDI.swift
//  CoreDataFramework
//
//  Created by Dmitry Samartcev on 09.04.2021.
//

import Foundation

/*
 Copying code
 Failed to work correctly with package 'Architecture' inside 'CoreDataFramework' due to 'Undefined symbol: protocol descriptor' errors
 */

public class Container {
    var singletones: [ObjectIdentifier : AnyObject] = [:]
    
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

/// A holder for using dependency injection via property wrappers
public final class ContainerHolder {
    public static var container: IContainer!
}

public protocol IContainer: AnyObject {
    func resolve<T: IResolvable>(args: T.Arguments) -> T
}

/// Responsible for the scope in which the object instance will exist
public enum InstanceScope {
    case perRequest // A new instance will be created for each call
    case singletone // Instance is created once on first call
}

public protocol IResolvable: AnyObject {
    associatedtype Arguments
    
    static var instanceScope: InstanceScope { get }

    init (container: IContainer, args: Arguments)
}

public protocol Singletonable: IResolvable where Arguments == Void { }

public extension Singletonable {
    static var instanceScope: InstanceScope { .singletone }
}

public protocol PerRequestable: IResolvable { }
extension PerRequestable {
    public static var instanceScope: InstanceScope { .perRequest }
}

