//
//  CustomButton.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            Text(self.title)
                .fontWeight(.medium)
                .font(.system(size: 10))
                .shadow(color: Color.systemBackground, radius: 0, x: 0, y: 1)
                .frame(minWidth: 60, maxWidth: .infinity, minHeight: 34)
                .foregroundColor(Color.primary)
                .background(Color.systemGray4)
                .cornerRadius(10)
        }
    }
}

#Preview {
    CustomButton(title: "Save") {
        print("pressed")
    }
}
