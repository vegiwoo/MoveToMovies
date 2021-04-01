//  IResolvable.swift
//  Created by Dmitry Samartcev on 31.03.2021.

import Foundation

public protocol IResolvable: AnyObject {
    associatedtype Arguments
    
    static var instanceScope: InstanceScope { get }
    // Initializer takes container and arguments
    // Each entity that implements this initializer will get the necessary dependencies from  container
    init (container: IContainer, args: Arguments)
}

public protocol Singletonable: IResolvable where Arguments == Void { }
extension Singletonable {
    public static var instanceScope: InstanceScope { .singletone }
}

public protocol PerRequestable: IResolvable { }
extension PerRequestable {
    public static var instanceScope: InstanceScope { .perRequest }
}

@propertyWrapper
public struct Resolvable<T: IResolvable> where T.Arguments == Void {
    private var cache: T?

    public init(){}
    
    public var wrappedValue: T {
        mutating get {
            if let cache = cache {
                return cache
            }
            let resolved: T = ContainerHolder.container.resolve(args: Void())
            cache = resolved
            return resolved
        }
    }
}
