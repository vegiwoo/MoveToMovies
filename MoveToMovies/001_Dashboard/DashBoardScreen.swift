//
//  DashBoardScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

struct DashBoardScreen: View, BaseView {
    
    var actualColor: Color
    var title: String

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var appState: AppState
    @ObservedObject var vm: DashboardViewModel = .init()
    @FetchRequest (entity: MovieItem.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \MovieItem.voteAverage, ascending: true)
    ]) var popularMovies: FetchedResults<MovieItem>
    
    init(actualColor: Color, title: String) {
        self.actualColor = actualColor
        self.title = title
    }

    var body: some View {
        VStack {
            ForEach(popularMovies, id: \.self) { movie in
                Text(movie.title ?? "")
            }
   
            Button(action: {
                appState.isQuickLink = true
            }, label: {
                Text("Get random movie")
            })
        }.onAppear {
            vm.setup(networkService: AppState.networkService, dataStorageService: AppState.dataStoreService)
        }
        
        
        
        
        
        
        
    }
}

struct DashBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text)
    }
}
