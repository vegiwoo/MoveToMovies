//  IContainer.swift
//  Created by Dmitry Samartcev on 31.03.2021.

import Foundation

public protocol IContainer: AnyObject {
    func resolve<T: IResolvable>(args: T.Arguments) -> T
}
