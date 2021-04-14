//
//  DashScreenContainerView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import Navigation

struct DashScreenContainerView: View{
    
    @EnvironmentObject var appStore: AppStore<AppState, AppAction, AppEnvironment>
    
    var body: some View {
        DashScreenRenderView()
    }
}

struct DashScreenContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DashScreenContainerView()
    }
}
