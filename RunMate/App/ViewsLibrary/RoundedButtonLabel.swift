import SwiftUI

enum ButtonStyle {
    case primary
    case secondary
    case alert

    var bgColor: Color {
        switch self {
        case .primary: return Color.green
        case .secondary: return Color.secondary
        case .alert: return Color.red
        }
    }
}

struct RoundedButtonLabel: View {
    let title: String
    let style: ButtonStyle

    var body: some View {
        return Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding()
            .frame(width: 100, height: 100, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(Color.primary)
            .clipShape(Circle())
            .shadow(radius: 8.0)
    }
}

struct RoundedButtonImage: View {
    let title: SFSymbolImage
    let style: ButtonStyle

    var body: some View {
        return Text("\(title.image)")
            .padding()
            .frame(width: 100, height: 100, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(Color.primary)
            .clipShape(Circle())
            .shadow(radius: 8.0)
    }
}
