//
//  WhatsLeftApp.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI
import SwiftData

@main
struct WhatsLeftApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: [Entry.self])
        }
    }
}
