//
//  AboutUsScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct AboutUsScreen: View {
    var body: some View {
        NavCoordinatorView() {
            AboutUsScreenContent()
        }
    }
}

struct AboutUsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsScreen()
    }
}


struct AboutUsScreenContent: View {
    var body: some View {
        Text("AboutUsScreen")
    }
}

struct AboutUsScreenContent_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsScreen()
    }
}
