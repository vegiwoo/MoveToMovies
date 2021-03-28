//  GeometryGetter.swift
//  Created by Dmitry Samartcev on 28.03.2021.

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
/// Передает фрейм представлений в привязке к родительскому элементу.
/// Здесь исполльзуется на Article Content и Image чтобы получить прямоугольники для обоих.
public struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    public init(rect: Binding<CGRect>) {
        self._rect = rect
    }
    
    public var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

@available(iOS 13.0, *)
public struct GeometryGetter_Previews: PreviewProvider {
    public static var previews: some View {
        GeometryGetter(rect: .constant(CGRect.zero))
    }
}
#endif
