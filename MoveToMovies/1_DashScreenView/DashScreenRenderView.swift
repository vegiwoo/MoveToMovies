//
//  DashScreenRenderView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 02.04.2021.
//

import SwiftUI
import Navigation
import UIControls

struct DashScreenRenderView: View {
    
    @EnvironmentObject var nc: NavCoordinatorViewModel
    @Binding private var readinessUpdatePopularTmbdMovies: Bool
    
    @State private var readinessForQuickTransition: Bool = false
    @Binding private var isQuickTransition: Bool
    
    init(readinessUpdatePopularTmbdMovies: Binding<Bool>, isQuickTransition: Binding<Bool>) {
        self._readinessUpdatePopularTmbdMovies = readinessUpdatePopularTmbdMovies
        self._isQuickTransition = isQuickTransition
    }
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ZStack {
                    Circle()
                        .foregroundColor(.gray)
                    if readinessUpdatePopularTmbdMovies {
                        Text("Get random\npopular movie")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .transition(.opacity)
                    } else {
                        VStack (spacing: 5) {
                            Text("Update")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                
                            ActivityIndicator(color: .white, style: .large, shouldAnimate: .constant(true))
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                        .transition(.opacity)
                    }
                }
                .frame(width: 150, height: 150, alignment: .center)
                .onTapGesture {
                    isQuickTransition = true
                }
            }
            Spacer()
        }
        .onChange(of: readinessUpdatePopularTmbdMovies, perform: { value in
            if value {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    self.readinessForQuickTransition = true
                }
            }
        })
    }
}

struct DashScreenRenderView_Previews: PreviewProvider {
    static var previews: some View {
        DashScreenRenderView(readinessUpdatePopularTmbdMovies: .constant(false), isQuickTransition: .constant(false))
    }
}
