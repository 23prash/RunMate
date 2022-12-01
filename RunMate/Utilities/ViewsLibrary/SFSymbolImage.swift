//
//  SFSymbolImage.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/9/22.
//

import Foundation
import SwiftUI

enum SFSymbolImage: String {
    case play = "play.circle"
    case pause = "pause.circle"
    case cross = "xmark"
}

extension SFSymbolImage {
    var image: Image {
        return Image(systemName: self.rawValue)
    }
}
