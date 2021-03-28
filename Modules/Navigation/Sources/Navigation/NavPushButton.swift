//  NavPushButton.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

/// Represents a navigation button to move forward in a navigation sequence.
@available(iOS 13.0, *)
public struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    @EnvironmentObject var vm: NavCoordinatorViewModel
    
    private let label: () -> Label
    private let destination: Destination
    
    public init (destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            vm.push(destination)
        }
    }
}

@available(iOS 13.0, *)
struct NavPushButton_Previews: PreviewProvider {
    static var previews: some View {
        NavPushButton(destination: AnyView(EmptyView()), label: {
            Text("")
        })
    }
}
#endif
