//
//  TodayView.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]
    
    enum Page: Int, CaseIterable, Identifiable, Hashable {
        case november, december, january
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .november: return "Ноември"
            case .december:  return "Декември"
            case .january:      return "Януари"
            }
        }
    }
    
    @State private var activePage: Page? = .december
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: .zero) {
                        ForEach(Page.allCases, id: \.self) { page in
                            pageView(for: page, geo: geo)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .id(page)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetLayout()
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $activePage)
            }
            .navigationTitle((activePage ?? .december).title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { EditButton() }
        }
    }

    @ViewBuilder
    private func pageView(for page: Page, geo: GeometryProxy) -> some View {
        let split = entries(for: page)
        VStack(spacing: .zero) {
            Text("Разходи")
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(split.expenses, id: \.self) { entry in
                        entryView(from: entry)
                    }
                }
                .padding(.vertical)
            }
    
            Text("Приходи")
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(split.incomes, id: \.self) { entry in
                        entryView(from: entry)
                    }
                }
                .padding(.vertical)
            }
            
            Spacer()
            summarySection(for: page)
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
    }

    private func summarySection(for page: Page) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Колко остават?")
            }
            Spacer()
            Text(formattedAmount(whatsLeft(from: allEntries(for: page))))
                .font(.headline)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func allEntries(for page: Page) -> [Entry] {
        let cal = Calendar.current
        let tz = TimeZone.current
        
        let novStart = cal.date(from: DateComponents(timeZone: tz, year: 2025, month: 11, day: 1))!
        let janStart = cal.date(from: DateComponents(timeZone: tz, year: 2026, month: 1, day: 1))!
        
        let allEntries = switch page {
        case .november: entries.filter { Calendar.current.isDate($0.createdAt, equalTo: novStart, toGranularity: .month) }
        case .december: entries.filter { Calendar.current.isDate($0.createdAt, equalTo: .now, toGranularity: .month) }
        case .january: entries.filter { Calendar.current.isDate($0.createdAt, equalTo: janStart, toGranularity: .month) }
        }
        
        return allEntries
    }
    
    private func entries(for page: Page) -> (expenses: [Entry], incomes: [Entry]) {
        let entries = allEntries(for: page)
        
        return (expenses: entries.filter { $0.type == .expense}, incomes: entries.filter { $0.type == .income })
    }
    
    private func whatsLeft(from entries: [Entry]) -> Decimal {
        var amount: Decimal = 0
        
        entries.forEach { entry in
            amount += entry.signedAmount
        }
        
        return amount
    }
    
    private func entryView(from entry: Entry) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.createdAt, format: .dateTime.day().month(.abbreviated).hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(label(for: entry))
            }
            Spacer()
            Text(formattedAmount(entry))
                .font(.headline)
                .foregroundStyle(entry.type == .expense ? .red : .green)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private func formattedAmount(_ entry: Entry) -> String {
        let amount = entry.amount as NSDecimalNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = entry.currencyCode
        return formatter.string(from: amount) ?? "\(entry.amount) \(entry.currencyCode)"
    }
    
    private func formattedAmount(_ decimal: Decimal) -> String {
        let amount = decimal as NSDecimalNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BGN"
        return formatter.string(from: amount) ?? "\(decimal) BGN"
    }

    private func label(for entry: Entry) -> String {
        if let category = entry.category {
            return "\(entry.type == .income ? "Приход" : "Разход") • \(category.rawValue.capitalized)"
        } else {
            return entry.type == .income ? "Приход" : "Разход"
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(entries[index]) }
        try? modelContext.save()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Entry.self, configurations: config)
    let context = container.mainContext
    context.insert(Entry(monthStart: .now, amount: 1200, currencyCode: "BGN", type: .income, category: .salary))
    context.insert(Entry(monthStart: .now, amount: 35.5, currencyCode: "BGN", type: .expense, category: .groceries))
    context.insert(Entry(monthStart: .now, amount: 15, currencyCode: "BGN", type: .expense, category: .transport))
    return TodayView().modelContainer(container)
}
