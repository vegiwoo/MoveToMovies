//
//  PopularMoviesScreen.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var shouldAnimate: Bool
    let style : UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

extension MovieListResultObject: Identifiable {}

extension RandomAccessCollection where Self.Element: Identifiable {
    public func isLast(_ item: Element) -> Bool {
        guard isEmpty == false else { return false }
        
        guard let itemIndex = lastIndex(where: {AnyHashable($0.id) == AnyHashable(item.id)})
        else { return false }
        return distance(from: itemIndex, to: endIndex) == 1
    }
}

final class PopularMoviesViewModel: ObservableObject {
    
    @Published private(set) var items: [MovieListResultObject] = .init()
    @Published private(set) var page: Int = 0
    @Published private(set) var isPageLoading: Bool = false
    
    func loadPage() {
        guard  isPageLoading == false else { return }
        
        isPageLoading = true
        page += 1
        
        TmdbAPI.DefaultAPI.moviePopularGet(apiKey: API.apiKey.description) { (response, error) in
            if let results = response?.results {
                self.items.append(contentsOf: results)
            }
            self.isPageLoading = false
        }
    }
}

struct CustomCell: View {
    
    @EnvironmentObject var vm: PopularMoviesViewModel
    
    var item: MovieListResultObject
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(item.title ?? "")").font(.headline)
            Text("\(item.releaseDate ?? "")").font(.callout)
            
            if vm.isPageLoading && vm.items.isLast(item) {
                Divider()
                ActivityIndicator(shouldAnimate: .constant(true), style: .medium)
            }
        }
    }
}

    
    

struct PopularMoviesScreen: View /*, SizeClassAdjustable*/ {
    
//    @EnvironmentObject var appState: AppState
    
    @ObservedObject var vm: PopularMoviesViewModel
//
//    @Environment(\.verticalSizeClass) var _verticalSizeClass
//    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
//    var verticalSizeClass: UserInterfaceSizeClass? { _verticalSizeClass }
//    var horizontalSizeClass: UserInterfaceSizeClass? { _horizontalSizeClass }

    var body: some View {
        NavigationView {
            List(vm.items){item in
                VStack(alignment: .leading){
                    CustomCell(item: item).environmentObject(vm)
                        .onAppear{
                            if vm.items.isLast(item) {
                                vm.loadPage()
                            }
                        }
                }
            }
        }
        
        
        
        
//        GeometryReader{geometry in
//            VStack {
//                Text("Popular Movies").font(Font.system(.largeTitle).bold()).padding(.bottom)
//                List(appState.appViewModel.popularMovies){ movie in
//                    PopularMoviesCell(movie: movie)
//                        .frame(width: geometry.size.width - 36, height: isPad ? geometry.size.height / 6 : isPadOrLandscapeMax ? geometry.size.height / 3 : geometry.size.height / 6)
//                        .onTapGesture {
//                            appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: movie))))
//                        }
//                }.listStyle(InsetListStyle())
//            }
//        }.onAppear{
//            if appState.isQuickLink {
//                appState.navigation.advance(NavigationItem(view: AnyView(MovieDetailScreen(movie: appState.randomMovie!))))
//            }
//        }
    }
}

struct PopularMoviesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesScreen(vm: PopularMoviesViewModel())
    }
}
