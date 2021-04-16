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
    
    @State var degrees: Double = 0
    
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
                        
                 
                        //.transition(.opacity)
                    }
                }
                .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 0, z: 0))
                .frame(width: 150, height: 150, alignment: .center)
                .onTapGesture {
                    isQuickTransition = true
                }
            }
            Spacer()
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8)) {
                readinessForQuickTransition = readinessUpdatePopularTmbdMovies
                degrees += 360
            }
        }
        .onChange(of: readinessUpdatePopularTmbdMovies, perform: { value in
            if value {
                withAnimation(Animation.easeInOut(duration: 0.8)) {
                    self.readinessForQuickTransition = true
                    degrees += 360
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
