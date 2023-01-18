//
//  UIDatePicker+date+extension.swift
//  Remind me
//
//  Created by Andrey Versta on 28.07.2022.
//

import Foundation

extension Date {
    func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = strFormat
        
        return dateFormatter.string(from: self)
    }
}
