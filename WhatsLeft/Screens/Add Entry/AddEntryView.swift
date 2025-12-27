//
//  AddEntryView.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI

struct AddEntryView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Spacer()
                        Text("Ноември, 2025")
                            .font(.caption)
                    }
                    .padding(.top, 8)
                    
                    Divider()
                        .padding(.bottom, 8)
                    
                    GlassTextField(
                        title: "Сума",
                        placeholder: "0.00 лв.",
                        text: .constant("")
                    )
                    
                    GlassTextField(
                        title: "Тип",
                        placeholder: "Разход",
                        text: .constant("Разход")
                    )
                    
                    GlassTextField(
                        title: "Причина",
                        placeholder: "Потребителски кредит",
                        text: .constant("Кредит")
                    )
                    
                    GlassTextField(
                        title: "За месец",
                        placeholder: "Ноември",
                        text: .constant("Ноември")
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Нов запис")
        }
    }
}

#Preview {
    AddEntryView()
}
