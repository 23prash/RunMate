import SwiftUI
import SweatUI

struct StartRunView: View {
    let quote: String
    let onStart: () -> Void
    
    private func quoteView() -> some View {
        Text(quote)
            .font(.largeTitle)
            .shiny()
            .multilineTextAlignment(.center)
            .foregroundColor(.orange)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.thickMaterial)
            )
    }
    
    var body: some View {
        VStack {
            Spacer()
            quoteView()
            Spacer()
            Button(action: {
                withAnimation {
                    onStart()
                }
            })
            {
                ButtonText.primary("Start Run")
            }.buttonStyle(SweatUIButtonStyle.primary)
                .padding(.bottom)
        }
    }
}
