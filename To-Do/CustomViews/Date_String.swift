//
//  Date_String.swift
//  To-Do
//
//  Created by MAG on 23/08/2023.
//

import Foundation

class DateAndString {
    func convertStringToDate(_ timeString: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        dateFormater.locale = Locale(identifier: "ar_EG")

        let calender = Calendar.current
        let currentDate = Date()

        let currentCom = calender.dateComponents([.year, .month, .day], from: currentDate)

        guard let combinedDate = calender.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate),
                let timeDate = dateFormater.date(from: timeString),
                let cominedDateTime = calender.date(bySettingHour: calender.component(.hour, from: timeDate), minute: calender.component(.minute, from: timeDate), second: calender.component( .second, from: timeDate), of: combinedDate)
        else {
            return nil
        }

        return cominedDateTime
    }

    func convertDateStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter.date(from: dateString)
    }
}
