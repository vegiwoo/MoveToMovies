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
            HStack {
                Image(systemName: "chevron.backward")
                Text(text).font(.title2)
            }
            .foregroundColor(color)
            .frame(width: width, alignment: .leading)
            .padding(.bottom)
        }
    }
}
