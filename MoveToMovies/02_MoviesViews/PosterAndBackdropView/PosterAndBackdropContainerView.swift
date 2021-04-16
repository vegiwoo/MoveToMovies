//
//  PosterAndBackdropContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.04.2021.
//

import SwiftUI
import Navigation 

struct PosterAndBackdropContainerView: View {
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    @EnvironmentObject private var ns: NavigationStack
    
    @State var isGotoPreviewsView: Bool = false
    
    var body: some View {
        PosterAndBackdropRenderView(posterData: posterData, backdropData: backdropData, isGotoPreviewsView: $isGotoPreviewsView).onAppear {
            print("ℹ️ Second nesting level of stack.")
        }
        .onChange(of: isGotoPreviewsView) { value in
            if value { ns.pop() }
        }
    }
}

extension PosterAndBackdropContainerView {
    private var posterData: Binding<Data?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMoviePoster)
    }
    private var backdropData: Binding<Data?> {
        appStore.binding(for: \.popularMovies.selectedTMDBMovieBackdrop)
    }
}

struct PosterAndBackdropContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PosterAndBackdropContainerView()
    }
}
