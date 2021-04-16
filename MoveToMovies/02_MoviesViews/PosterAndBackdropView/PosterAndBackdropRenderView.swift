//
//  PosterAndBackdropRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//

import SwiftUI
import UIControls
import Navigation

struct PosterAndBackdropRenderView: View {
    
    @Binding var posterData: Data?
    @Binding var backdropData: Data?
    @Binding var isGotoPreviewsView: Bool
    
    init(posterData: Binding<Data?>, backdropData: Binding<Data?>, isGotoPreviewsView: Binding<Bool>) {
        self._posterData = posterData
        self._backdropData = backdropData
        self._isGotoPreviewsView = isGotoPreviewsView
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                VStack {
                    Spacer()
                    HStack (spacing: 16) {
                        VStack (spacing: 10) {
                            if let posterData = posterData,
                               let uiImage = UIImage(data: posterData) {
                                PushView(destination: PosterOrBackdropContainerView(posterData: $posterData, backdropData: .constant(nil))) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150, alignment: .center)
                                }
                            } else {
                                Circle()
                            }
                            Text("Poster").infoStyle()
                        }
                        VStack (spacing: 10) {
                            if let backdropData = backdropData,
                               let uiImage = UIImage(data: backdropData) {
                                PushView(destination: PosterOrBackdropContainerView(posterData: .constant(nil), backdropData: $backdropData)) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150, alignment: .center)
                                }
                            } else {
                                Circle()
                            }
                            Text("Backdrop").infoStyle()
                        }
                    }
                    .frame(height: geometry.size.height / 5)
                    Spacer()
                }.frame(width: geometry.size.width)
                CircleBackButtonLabel().onTapGesture {
                    isGotoPreviewsView = true
                }
            }
        }
        .frame(alignment: .center)
    }
}

struct PosterAndBackdropRenderView_Previews: PreviewProvider {
    static var previews: some View {
        PosterAndBackdropRenderView(posterData: .constant(nil),
                                    backdropData: .constant(nil),
                                    isGotoPreviewsView: .constant(false))
    }
}
