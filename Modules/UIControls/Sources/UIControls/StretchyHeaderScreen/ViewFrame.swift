//  ViewFrame.swift
//  Created by Dmitry Samartcev on 28.03.2021.

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public class ViewFrame: ObservableObject {
    var startingRect: CGRect?
    @Published var frame: CGRect {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
    public init() {self.frame = .zero}

}
#endif
