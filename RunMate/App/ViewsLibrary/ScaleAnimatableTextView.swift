//
//  ScaleAnimatableTextView.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/5/22.
//

import SwiftUI

struct ScaleAnimatableTextView: View {
    private let text: String
    private let startSize: CGFloat
    private let endSize: CGFloat
    @State var fontSize: CGFloat

    private let timer = Timer.publish(every: 0.1,
                                      on: .main,
                                      in: .common).autoconnect()

    init(text: String, startFontSize: CGFloat, endFontSize: CGFloat) {
        self.text = text
        startSize = startFontSize
        endSize = endFontSize
        fontSize = startSize
    }

    var body: some View {
        Text(text)
            .animatableSystemFont(size: fontSize)
            .onReceive(timer) { _ in
                guard fontSize == startSize else {
                    timer.upstream.connect().cancel()
                    return
                }
                withAnimation(.easeOut(duration: 0.5)) {
                    fontSize = endSize
                }
            }
    }
}

struct ScaleAnimatableTextView_Previews: PreviewProvider {
    static var previews: some View {
        ScaleAnimatableTextView(text: "Hello!", startFontSize: 100, endFontSize: 200)
    }
}
