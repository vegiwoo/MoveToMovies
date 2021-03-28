//
//  BackButton.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 09.03.2021.
//

import SwiftUI

@available(iOS 13.0, *)
public struct BackButton: View {
    
    public let width: CGFloat
    public let text: String
    public let color: Color
    public let action: (() -> Void)?
    
    public init(width: CGFloat, text: String, color: Color, action: (() -> Void)? = nil )  {
        self.width = width
        self.text = text
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button {
            if let existingAction = action {
                existingAction()
            }
        } label: {
            BackButtonLabel(text: text, color: color, width: width)
        }
    }
}

@available(iOS 13.0, *)
public struct BackButtonLabel: View {
    
    public let text: String
    public let color: Color
    public let width: CGFloat
    
    public init(text: String, color: Color, width: CGFloat) {
        self.text = text
        self.color = color
        self.width = width
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "chevron.backward")
            Text(text).multilineTextAlignment(.leading)
        }
        .foregroundColor(color)
        .frame(width: width, alignment: .leading)
    }
}
