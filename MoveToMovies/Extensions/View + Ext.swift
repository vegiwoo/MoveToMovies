//
//  View + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.03.2021.
//

import SwiftUI
import Combine

extension View {
    var id: UUID {
        return UUID()
    }
}

//extension View {
//    /// A backwards compatible wrapper for iOS 14 `onChange`
//    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
//        if #available(iOS 14.0, *) {
//            self.onChange(of: value, perform: onChange)
//        } else {
//        self.onReceive(Just(value)) { (value) in
//                onChange(value)
//            }
//        }
//    }
//}
//
////// .onChange for later iOS 14.0
//struct ChangeObserver<Base: View, Value: Equatable>: View {
//    let base: Base
//    let value: Value
//    let action: (Value)->Void
//
//    let model = Model()
//
//    var body: some View {
//        if model.update(value: value) {
//            DispatchQueue.main.async { self.action(self.value) }
//        }
//        return base
//    }
//
//    class Model {
//        private var savedValue: Value?
//        func update(value: Value) -> Bool {
//            guard value != savedValue else { return false }
//            savedValue = value
//            return true
//        }
//    }
//}
//
//extension View {
//    /// - Parameters:
//    ///   - value: The value to check against when determining whether to run the closure.
//    ///   - action: A closure to run when the value changes.
//    ///   - newValue: The new value that failed the comparison check.
//    /// - Returns: A modified version of this view
//    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (_ newValue: Value) -> Void) -> ChangeObserver<Self, Value> {
//        ChangeObserver(base: self, value: value, action: action)
//    }
//
//}
