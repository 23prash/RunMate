//
//  Common+Extensions.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation
import CoreLocation
import SwiftUI

extension TimeInterval {

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

extension String {
    func isValid(inputType: TextInputType) -> Bool {
        switch inputType {
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: self)
        case .name:
            return self.count >= 2
        case .password:
            return self.count >= 10
        case let .plainText(required):
            return required ? !self.isEmpty : true
        }
    }
}

enum TextInputType {
    case email
    case name
    case password
    case plainText(required: Bool)

    var isSecure: Bool {
        switch self {
        case .email, .name, .plainText:
            return false
        case .password:
            return true
        }
    }
}
