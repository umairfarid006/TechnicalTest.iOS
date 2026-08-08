//
//  String+.swift
//  BrightAbsences
//
//  Created by Umair on 08/08/2026.
//

import Foundation

extension String {
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy"

        return outputFormatter.string(from: date)
    }

    func addingDays(_ days: Int) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: self),
              let newDate = Calendar.current.date(
                byAdding: .day,
                value: days,
                to: date
              ) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy"

        return outputFormatter.string(from: newDate)
    }
}
