//
//  CustomButton.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftUI

struct DateCard: View {
    var date: String
    var month: String
    var name: String
    var time: String

    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .shadow(color: Color.systemBackground, radius: 0, x: 0, y: 1)
                .frame(width: 60, height: 60)
                .foregroundColor(Color.systemGray4)
                .overlay(
                    VStack {
                        Text(date)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color.primary)
                        Text(month)
                            .font(.system(size: 10))
                            .foregroundColor(Color.primary)
                    }
                )
                .padding(.trailing, 4)

            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.system(size: 20, weight: .semibold))
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(Color.systemGray)
            }
        }
    }
}

#Preview {
    let formatter = DateFormatter()
    let date = Date.now

    return NavigationStack {
        DateCard(
            date: date.dayOfWeek(withFormatter: formatter) ?? "",
            month: date.nameOfMonth(withFormatter: formatter) ?? "",
            name: "test",
            time: "test2"
        )
    }
}
