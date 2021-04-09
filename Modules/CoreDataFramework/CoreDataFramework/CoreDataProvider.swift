//
//  CoreDataProvider.swift
//  CoreDataFramework
//
//  Created by Dmitry Samartcev on 09.04.2021.
//

import Foundation
import CoreData

public class CoreDataProvider: Singletonable {
    public required init(container: IContainer, args: Void) { }
    
    public func hello() {
        print("Hello from CoreDataProvider")
    }
}
