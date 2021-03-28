//  CircleBackButtonLabel.swift
//  Created by Dmitry Samartcev on 28.03.2021.

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, *)
public struct CircleBackButtonLabel: View {
    
    public init() {}
    public var body: some View {
        HStack{
            Spacer()
            ZStack{
                Circle()
                    .frame(width: 80, height: 80, alignment: .trailing)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                Image(systemName: "arrow.backward").foregroundColor(.blue).font(.title)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing, 32)
        .padding(.bottom, 16)
    }
}

@available(iOS 13.0, *)
public struct CircleBackButtonLabel_Previews: PreviewProvider {
    public static var previews: some View {
        CircleBackButtonLabel()
    }
}
#endif
