//
//  EntryCategory.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 27.12.25.
//

import Foundation

public enum EntryCategory: String, Codable, CaseIterable {
    case salary
    case sale
    case creditPayment
    case groceries
    case dining
    case rent
    case utilities
    case transport
    case healthcare
    case entertainment
    case education
    case gifts
    case other
}
