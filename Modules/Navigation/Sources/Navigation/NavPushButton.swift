//  NavPushButton.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

/// Represents a navigation button to move forward in a navigation sequence.
@available(iOS 13.0, *)
public struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    @EnvironmentObject var vm: NavCoordinatorViewModel
    
    private let destination: Destination
    private let action: (() -> Void)?
    private let label: () -> Label
    
    public init (destination: Destination, action: (() -> Void)? = nil, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            if let existingAction = action {
                existingAction()
            }
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
