//
//  BackButton.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 09.03.2021.
//

import SwiftUI

struct BackButton: View {
    
    let width: CGFloat
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            
        }
    }
}
