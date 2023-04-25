import SwiftUI
import SweatUI

struct CardViewModifier: ViewModifier {
    let cornerRadius: Double
    func body(content: Content) -> some View {
        content
            .background(
                Color.white.opacity(0.95),
                in: RoundedRectangle(cornerRadius: cornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Theme.primaryBrand, lineWidth: 0.5)
            )
    }
}

extension View {
    func makeCard(cornerRadius radius: Double) -> some View {
        modifier(CardViewModifier(cornerRadius: radius))
    }
}
