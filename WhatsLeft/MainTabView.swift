//
//  MainTabView.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Днес", systemImage: "text.rectangle.page") {
                TodayView()
            }
            
            Tab("Статистика", systemImage: "align.vertical.bottom") {
                StatsView()
            }
            
            Tab("Настройки", systemImage: "dial.medium") {
                SettingsView()
            }
            
            Tab("Добави", systemImage: "plus", role: .search) {
                AddEntryView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Entry.self], inMemory: true)
}
