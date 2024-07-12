//
//  SheetBarItem.swift
//  TimeTracker
//
//  Created by Florian Bauer on 29.12.21.
//

import SwiftUI

struct StreamBarItem: View {
    var currentIndex: Int
    var namespace: Namespace.ID
    var title: String
    var tab: Int
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                if currentIndex == tab {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.systemGray5)
                        .frame(width: 64, height: 34, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.systemBackground,
                                        lineWidth: 4)
                                .shadow(color: Color.systemGray5, radius: 0, x: 0, y: 1)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                )
                        )
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                }
                Text(title)
                    .font(.system(size: 10))
                    .fontWeight(.medium)
                    .tracking(-1)
                    .frame(width: 64, height: 34, alignment: .center)
            }.animation(.easeInOut, value: currentIndex)
        }
        .buttonStyle(.plain)
        .padding(3)
    }
}
