//
//  View Modifies.swift
//  Tic Tac Toe?
//
//  Created by Harish on 7/9/23.
//

import SwiftUI

struct NavStackeContainer: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            NavigationStack{
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension View {
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackeContainer() )
    }
}
