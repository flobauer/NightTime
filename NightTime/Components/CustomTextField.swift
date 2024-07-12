//
//  CustomTextField.swift
//  NightTime
//
//  Created by Florian Bauer on 04.01.24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var textField: TextField<Text>
    var focus: FocusState<Bool>.Binding
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.systemGray)
                .font(.system(size: 24))
            textField
                .padding(.vertical, 10)
        }
        .padding(.leading, 10)
        .background(Color.systemGray6)
        .cornerRadius(10)
        .shadow(color: .systemBackground, radius: 2, x: 1, y: 1)
        .shadow(color: .systemGray4, radius: 1, x: -1, y: -1)
        .focused(self.focus)
    }
}
