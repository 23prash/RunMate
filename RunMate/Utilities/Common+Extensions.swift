//
//  Common+Extensions.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation
import CoreLocation
import SwiftUI

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)

    }
}

struct RunDateFormatter {
    static let defaultFormatter = getDefaultFormatter()
    private static func getDefaultFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

extension CLAuthorizationStatus {
    var 👍: Bool { self == .authorizedAlways || self == .authorizedWhenInUse }
    var 👎: Bool { !👍 }
}

struct WrapInDividers: ViewModifier {
    private let edges: Edge.Set

    init(_ edges: Edge.Set) {
        self.edges = edges
    }

    func body(content: Content) -> some View {
        HStack {
            if edges.contains(.trailing) {
                Divider()
                    .rotationEffect(.degrees(90))
            }
            VStack {
                if edges.contains(.top) {
                    Divider()
                }
                content
                if edges.contains(.bottom) {
                    Divider()
                }
            }
            if edges.contains(.trailing) {
                Divider()
                    .rotationEffect(.degrees(90))
            }
        }

    }
}

extension View {
    func wrappedInDividers(on edges: Edge.Set = [.vertical]) -> some View {
        return modifier(WrapInDividers(edges))
    }
}
