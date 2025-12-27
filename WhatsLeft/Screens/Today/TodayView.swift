//
//  TodayView.swift
//  WhatsLeft
//
//  Created by Borislav Borisov on 28.11.25.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Ноември")
                    Divider()
                }
                .padding(.horizontal, 16)
            }
            .background(Color.ghostWhite)
            .navigationTitle("Днес")
        }
    }
}

#Preview {
    TodayView()
}
