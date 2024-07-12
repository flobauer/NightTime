//
//  ClockFace.swift
//  TimeTracker
//
//  Created by Florian Bauer on 29.12.21.
//

import AVFoundation
import CoreHaptics
import SwiftUI

struct ClockZeiger: View {
    let radius: Double
    let color: Color
    @Binding var round: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .stroke(color, lineWidth: 3)
                    .frame(width: radius * 2, height: radius * 2)
                    .shadow(color: Color.systemBackground, radius: 5, x: 1, y: 1)
                Circle()
                    .fill(color)
                    .frame(width: radius * 2, height: radius * 2)
                    .clipped()
                    .shadow(color: Color.systemBackground, radius: 5, x: 1, y: 1)
            }
            if round {
                Rectangle()
                    .fill(color)
                    .frame(width: 3, height: 30)
            }
        }
    }
}
