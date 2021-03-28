//  NavPopButton.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

/// Represents a navigation button to move backward in a navigation sequence.
@available(iOS 13.0, *)
public struct NavPopButton<Label>: View where Label: View {
    @EnvironmentObject var vm: NavCoordinatorViewModel

    private let destination: PopDestination
    private let label: () -> Label
    private let action: (() -> Void)?
    
    public init (destination: PopDestination = .previous,
                 action: (() -> Void)? = nil,
                 @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
        self.action = action
    }
    
    public var body: some View {
        label().onTapGesture {
            if let existingAction = action {
                existingAction()
            }
            vm.pop(to: destination)
        }
    }
}

@available(iOS 13.0, *)
public struct NavPopButton_Previews: PreviewProvider {
    
    public static func stubFunction() {
        print("NavPopButton pop")
    }

    public static var previews: some View {
        NavPopButton{
            Text("Hrllo NavPopButton")
        }
    }
}
#endif
