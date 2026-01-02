//
//  Entry.swift
//  WhatsLeft
//

import Foundation
import SwiftData

@Model final class Entry {
    private(set) var createdAt: Date
    private(set) var amount: Decimal
    private(set) var currencyCode: String
    private(set) var monthStart: Date
    private(set) var type: EntryType
    private(set) var category: EntryCategory?
    
    init(
        createdAt: Date = .now,
        monthStart: Date,
        amount: Decimal,
        currencyCode: String,
        type: EntryType,
        category: EntryCategory? = nil
    ) {
        self.createdAt = createdAt
        self.monthStart = monthStart
        self.amount = amount
        self.currencyCode = currencyCode
        self.type = type
        self.category = category
    }
    
    static func startOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        if let startOfMonth = calendar.date(from: components) {
            return startOfMonth
        } else {
            return calendar.startOfDay(for: date)
        }
    }
    
    var signedAmount: Decimal {
        type == .expense ? -amount : amount
    }
}

