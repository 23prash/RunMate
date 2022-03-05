//
//  Common+Extensions.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation

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
