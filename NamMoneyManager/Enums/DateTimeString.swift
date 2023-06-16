//
//  TimeString.swift
//  NamMoneyManager
//
//  Created by Admin on 5/2/23.
//
import Foundation

enum DateTimeString: String {
    case minute
    case hour
    case day
    case week
    case year

    func getText(for dateTimeString: DateTimeString) -> String {
        switch dateTimeString {
        case .minute:
            return "# minute ago"
        case .hour:
            return "# hour ago"
        case .day:
            return "# day ago"
        case .week:
            return "# week ago"
        case .year:
            return "# year ago"
        }
    }
}
