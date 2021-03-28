
//  ActivityIndicator.swift
//  Created by Dmitry Samartcev on 28.03.2021.

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct ActivityIndicator: UIViewRepresentable {
    
    // ActivityIndicator(shouldAnimate: .constant(true), style: .large)
    
    public var style: UIActivityIndicatorView.Style
    @Binding var shouldAnimate: Bool
    
    
    public init(style: UIActivityIndicatorView.Style, shouldAnimate: Binding<Bool>) {
        self.style = style
        self._shouldAnimate = shouldAnimate
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView()
        view.style = .large
        view.hidesWhenStopped = true
        return view
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }

    }
}

@available(iOS 13.0, *)
public struct ActivityIndicator_Previews: PreviewProvider {
    public static var previews: some View {
        VStack {
            ActivityIndicator(style: .medium, shouldAnimate: .constant(true))
        }
    }
}
#endif
