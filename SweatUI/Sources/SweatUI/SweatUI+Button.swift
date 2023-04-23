import SwiftUI

public struct SweatUIButtonStyle: ButtonStyle {
    var style: ButtonStyleParams
    
    public static var primary: SweatUIButtonStyle {
        return .init(style: ButtonStyleParams(color: Theme.primaryAction, borderColor: .clear))
    }
    
    public static var secondary: SweatUIButtonStyle {
        return  .init(style: ButtonStyleParams(color: Theme.secondaryAction, borderColor: Theme.primaryAction))
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Capsule())
            .foregroundColor(configuration.isPressed ? style.color.opacity(0.85) : style.color)
            .scaleEffect(configuration.isPressed ? CGFloat(style.scale) : 1.0)
            .overlay(
                Capsule()
                    .stroke(style.borderColor, lineWidth: 2)
                    .scaleEffect(configuration.isPressed ? style.scale : 1)
            )
            .animation(style.animate ? Animation.interactiveSpring() : .none, value: configuration.isPressed)
    }
}

public struct ButtonText: View {
    let text: String
    let color: Color
    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }
    public var body: some View {
        Text(text)
            .padding()
            .foregroundColor(color)
            .font(.title2.bold())
    }
}

public extension ButtonText {
    static func primary(_ text: String) -> Self {
        return ButtonText(text, color: Theme.primaryActionTitle)
    }
    
    static func secondary(_ text: String) -> Self {
        return ButtonText(text, color: Theme.secondaryActionTitle)
    }
}

struct ButtonStyleParams {
    let scale: Double = 1.25
    let color: Color
    let animate: Bool = true
    let borderColor: Color
}

