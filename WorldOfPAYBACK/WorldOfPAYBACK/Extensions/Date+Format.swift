//
//  Date+Format.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import Foundation

extension Date {
    var formated: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
