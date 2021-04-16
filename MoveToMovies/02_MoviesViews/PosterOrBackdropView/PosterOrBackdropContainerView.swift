//
//  PosterOrBackdropContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//

import SwiftUI
import Navigation

struct PosterOrBackdropContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack
    
    @State var isGotoPreviewsView: Bool = false
    
    @Binding var posterData: Data?
    @Binding var backdropData: Data?
    
    var body: some View {
        PosterOrBackdropRenderView(posterData: $posterData, backdropData: $backdropData, isGotoPreviewsView: $isGotoPreviewsView)
            .onAppear {
                print("ℹ️ Third level of nesting of stack.")
            }.onChange(of: isGotoPreviewsView) { (value) in
                if value { ns.pop()}
            }
    }
}

struct PosterOrBackdropContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PosterOrBackdropContainerView(posterData: .constant(nil),
                                      backdropData: .constant(nil))
    }
}
