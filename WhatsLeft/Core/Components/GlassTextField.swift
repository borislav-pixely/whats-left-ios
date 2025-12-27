//
//  GlassTextField.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI

struct GlassTextField: View {
    let title: String
    let placeholder: String

    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Glass container
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(radius: isFocused ? 50 : 0, y: isFocused ? 10 : 0)

            // Content
            VStack(alignment: .leading, spacing: 6) {
                // Tiny label in the top-left
                Text(title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                // Actual text field
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .tint(.accentColor)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
    }
}
