//
//  Date+Extensions.swift
//  InBody_HealthKit
//
//  Created by 장선영 on 2022/04/28.
//

import Foundation

extension Date {
    func toStringWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
    
    func toStringWithTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
    
    func toCurrentTimezone() -> Date {
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        return self.addingTimeInterval(timeZoneDifference)
    }
}
