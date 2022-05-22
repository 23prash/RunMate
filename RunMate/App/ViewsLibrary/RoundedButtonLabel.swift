import SwiftUI

enum ButtonStyle {
    case primary
    case secondary
    case tertiary
    case alert

    var bgColor: Color {
        switch self {
        case .primary: return Color(red: 75/255, green: 191/255, blue: 68/255)
        case .secondary: return Color.secondary
        case .alert: return Color.red
        case .tertiary: return .clear
        }
    }

    var borderColor: Color {
        switch self {
        case .primary: return .clear
        case .secondary: return .clear
        case .alert: return .clear
        case .tertiary: return .brandColor
        }
    }
}

struct RoundedButtonLabel: View {
    let title: String
    let subtitle: String?
    let style: ButtonStyle

    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
            }
        }.padding()
            .frame(width: 60, height: 60, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(.brandColor)
            .clipShape(Circle())
            .border(style.borderColor, width: 1)
            .shadow(radius: 5.0)
    }
}

struct RoundedButtonImage: View {
    let title: SFSymbolImage
    let subtitle: String?
    let style: ButtonStyle

    var body: some View {
        VStack {
            Text(title.image)
                .font(.title3)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
            }
        }.padding()
            .frame(width: 60, height: 60, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(.brandColor)
            .clipShape(Circle())
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.thinMaterial, lineWidth: 1)
            )
    }
}

struct ActionButtonLabel: View {

    enum `Type` {
        case primary
        case secondary
    }
    private let title: String
    private let type: Type
    init(title: String,
         type: Type) {
        self.type = type
        self.title = title
    }

    private var bgColor: Color {
        switch type {
        case .primary:
            return Color.brandColor
        case .secondary:
            return Color.secondary
        }
    }

    private var fgColor: Color {
        switch type {
        case .primary:
            return Color.white
        case .secondary:
            return Color.white
        }
    }

    var body: some View {
        Text(title)
            .padding([.horizontal], 100)
            .padding([.vertical], 16)
            .background(bgColor)
            .foregroundColor(fgColor)
            .cornerRadius(10)
    }
}
