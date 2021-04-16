//
//  PosterOrBackdropRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//

import SwiftUI
import UIControls

struct PosterOrBackdropRenderView: View {
    
    @Binding var posterData: Data?
    @Binding var backdropData: Data?
    @Binding var isGotoPreviewsView: Bool

    
    init(posterData: Binding<Data?>, backdropData: Binding<Data?>, isGotoPreviewsView: Binding<Bool>) {
        self._posterData = posterData
        self._backdropData = backdropData
        self._isGotoPreviewsView = isGotoPreviewsView

    }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                Group {
                    if let posterData = posterData,
                       let image = UIImage(data: posterData) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if let backdropData = backdropData,
                              let image = UIImage(data: backdropData) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Text("No data to preview")
                    }
                }
                .frame(maxWidth: geometry.size.width, idealHeight: geometry.size.height, maxHeight: .infinity)
                CircleBackButtonLabel().onTapGesture {
                    withAnimation {
                        isGotoPreviewsView = true
                    }
                }.frame(width: 80, height: 80, alignment: .center)
            }
            .ignoresSafeArea()
        }
    }
}

struct PosterOrBackdropRenderView_Previews: PreviewProvider {
    static var previews: some View {
        PosterOrBackdropRenderView(posterData: .constant(nil),
                                   backdropData: .constant(nil),
                                   isGotoPreviewsView: .constant(false))
    }
}
