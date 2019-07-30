//
//  DateExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
}

extension Date {
    static func date(from dateString: String, dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = dateFormat.rawValue
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        return date
    }
    
    static func dateString(from date: Date, dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = dateFormat.rawValue
        
        return dateFormatter.string(from: date)
    }
    
    static func currentDateString(dateFormat: DateFormat = .yyyyMMddHHmmss) -> String {
        return Date.dateString(from: Date(), dateFormat: dateFormat)
    }
    
    static func currentDateTimeIntervalSince1970() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    static func transformDateString(_ dateString: String, from oldDateFormat: DateFormat, to newDateFormat: DateFormat) -> String? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = oldDateFormat.rawValue
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        dateFormatter.dateFormat = newDateFormat.rawValue
        
        return dateFormatter.string(from: date)
    }
}
