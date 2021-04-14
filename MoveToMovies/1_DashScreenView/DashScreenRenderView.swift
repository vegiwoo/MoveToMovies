//
//  DashScreenRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import Navigation

struct DashScreenRenderView: View {
    
    @EnvironmentObject var nc: NavCoordinatorViewModel
    
    var body: some View {
        PushView(destination: EmptyView().background(Color.red)) {
            Text("Push")
                .padding()
                .foregroundColor(.green)
                .background(Color.yellow)
        }
    }
}

struct DashScreenRenderView_Previews: PreviewProvider {
    static var previews: some View {
        DashScreenRenderView()
    }
}
