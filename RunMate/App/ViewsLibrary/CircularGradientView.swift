//
//  CircularGradientView.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/5/22.
//

import SwiftUI

struct CircularGradientView: View {
    private let startColor: Color
    private let endColor: Color

    init(colorAtCenter: Color = .clear, colorAtEdge: Color = .white) {
        startColor = colorAtCenter
        endColor = colorAtEdge
    }

    var body: some View {
        GeometryReader { geometry in
            RadialGradient(colors: [startColor, endColor],
                           center: .center,
                           startRadius: 0,
                           endRadius: sqrt((geometry.size.width/2 * geometry.size.width/2) + (geometry.size.height/2 * geometry.size.height/2)))
        }
    }
}

struct CircularGradientView_Previews: PreviewProvider {
    static var previews: some View {
        CircularGradientView()
    }
}
