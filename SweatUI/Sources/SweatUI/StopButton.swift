//
//  SwiftUIView.swift
//  
//
//  Created by macbook on 24/4/2023.
//

import SwiftUI

public struct FinishButton: View {
    public var action: () -> Void
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    public var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .accessibility(addTraits: .isButton)
                .accessibilityAction { self.performTap() }
                .contentShape(Rectangle())
                .onTapGesture { self.performTap() }
                .padding(proxy.size.width/4)
                .background(Theme.primaryAlert.opacity(0.8), in: Circle())
        }
    }
    
    private func performTap() {
        action()
    }
}
