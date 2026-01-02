//
//  AddEntryView.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amountString: String = ""
    @State private var type: EntryType = .expense
    @State private var category: EntryCategory? = nil
    @State private var currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    @State private var createdAt: Date = .now
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .bottom) {
                        Spacer()
                        Text(createdAt, format: .dateTime.month(.wide).year())
                            .font(.caption)
                    }
                    .padding(.top, 8)
                    
                    Divider()
                        .padding(.bottom, 8)
                    
                    GlassTextField(
                        title: "Сума",
                        placeholder: "0.00 \(currencyCode)",
                        text: $amountString
                    )
                    
                    Picker("Тип", selection: $type) {
                        Text("Приход").tag(EntryType.income)
                        Text("Разход").tag(EntryType.expense)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Категория", selection: $category) {
                        Text("Без категория").tag(EntryCategory?.none)
                        ForEach(EntryCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue.capitalized).tag(Optional(cat))
                        }
                    }
                    
                    TextField("Валута (напр. BGN)", text: $currencyCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    
                    DatePicker("Дата", selection: $createdAt, displayedComponents: [.date, .hourAndMinute])
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Нов запис")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Запази") {
                        saveEntry()
                    }
                    .disabled(decimal(from: amountString) == nil)
                }
            }
        }
    }
    
    private func decimal(from string: String) -> Decimal? {
        let normalized = string.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines)
        return Decimal(string: normalized)
    }
    
    private func saveEntry() {
        guard let amount = decimal(from: amountString) else { return }
        let entry = Entry(
            createdAt: createdAt,
            monthStart: Entry.startOfMonth(for: createdAt),
            amount: amount,
            currencyCode: currencyCode,
            type: type,
            category: category
        )
        modelContext.insert(entry)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AddEntryView()
        .modelContainer(for: [Entry.self], inMemory: true)
}
