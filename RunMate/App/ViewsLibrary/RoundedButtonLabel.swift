import SwiftUI

enum ButtonStyle {
    case success
    case secondary
    case alert

    var bgColor: Color {
        switch self {
        case .success: return Color(red: 75/255, green: 191/255, blue: 68/255)
        case .secondary: return Color.secondary
        case .alert: return Color.red
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
            .frame(width: 100, height: 100, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(Color.white)
            .clipShape(Circle())
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
            .frame(width: 100, height: 100, alignment: .center)
            .background(style.bgColor)
            .foregroundColor(Color.white)
            .clipShape(Circle())
            .shadow(radius: 5.0)
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
