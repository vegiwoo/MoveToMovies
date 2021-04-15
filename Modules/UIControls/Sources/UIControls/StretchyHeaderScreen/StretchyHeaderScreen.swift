//  StretchyHeader.swift
//  Created by Dmitry Samartcev on 28.03.2021.

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct StretchyHeaderScreen: View {
    
    private let imageHeight: CGFloat = 500
    private let collapsedImageHeight: CGFloat = 75
    
    private let title: String
    private let content: AnyView
    private let imageData: Data
    
    @ObservedObject private var articleContent: ViewFrame = ViewFrame()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero

    public init(imageData: Data, title: String, content: AnyView) {
        self.imageData = imageData
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text(title)
                        .background(GeometryGetter(rect: self.$titleRect))
                    content
                }
                .padding(.horizontal)
                .padding(.top, 16.0)
            }
            .offset(y: imageHeight + 16)
            .background(GeometryGetter(rect: $articleContent.frame))

            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .blur(radius: self.getBlurRadiusForImage(geometry))
                        .clipped()
                        .background(GeometryGetter(rect: self.$headerImageRect))

                    Text(title)
                        .font(Font.system(size: 24))
                        .foregroundColor(.white)
                        .offset(x: 0, y: self.getHeaderTitleOffset())
                }
                .clipped()
                .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }
            .frame(height: imageHeight)
            .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
        }
    }
}

@available(iOS 13.0, *)
extension StretchyHeaderScreen {
    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
           geometry.frame(in: .global).minY
    }
    
    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight
        
        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }
        if offset > 0 {
            return -offset
            
        }
        return 0
    }
    
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
    
    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height
        return blur * 6
    }
    
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        
        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0
            let maxYValue: CGFloat = collapsedImageHeight
            let currentYValue = currentYPos

            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
            let finalOffset: CGFloat = -30.0
            
            return 20 - (percentage * finalOffset)
        }
        
        return .infinity
    }
}

//@available(iOS 13.0, *)
//struct StretchyHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        StretchyHeader(imageData: <#Data#>, title: <#String#>, content: <#AnyView#>)
//    }
//}
#endif
