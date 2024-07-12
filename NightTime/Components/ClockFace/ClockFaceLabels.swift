//
//  ClockfaceBackground.swift
//  NightTime
//
//  Created by Florian Bauer on 12.07.24.
//

import Foundation

import AVFoundation
import CoreHaptics
import SwiftUI

struct ClockFaceLabels: View {
    let rectangleWidth: Double
    let radius: CGFloat
    @Binding var round: Bool

    var rectangelWidthPadding: Double {
        return Double(rectangleWidth - 10)
    }

    var body: some View {
        ZStack {
            // Seconds and Minutes
            ForEach(0 ..< 60, id: \.self) { i in
                Rectangle()
                    .fill(Color.primary.opacity((i % 5) == 0 ? 1 : 0.4))
                    .frame(width: 1, height: (i % 5) == 0 ? 12 : 8)
                    .offset(
                        x: round ? 0 : CGFloat(
                            (Int(i + 1) * Int(rectangelWidthPadding) / 60) - Int(rectangelWidthPadding)
                        ),
                        y: round ? radius : 0
                    )
                    .rotationEffect(.degrees(round ? Double(i) * 6 : 0))
            }

        }.offset(x: round ? 0 : rectangelWidthPadding / 2)

        ZStack {
            Text("12")
                .foregroundColor(Color.primary)
                .font(.system(size: 10))
                .offset(
                    x: round ? 0 : -rectangelWidthPadding / 6 + 5,
                    y: round ? -(radius - 12) : 14
                )
            Text("15")
                .foregroundColor(Color.primary)
                .font(.system(size: 10))
                .offset(
                    x: round ? radius - 12 : 5,
                    y: round ? 0 : 14
                )
            Text("18")
                .foregroundColor(Color.primary)
                .font(.system(size: 10))
                .offset(
                    x: round ? 0 : rectangelWidthPadding / 6 + 5,
                    y: round ? radius - 12 : 14
                )
            Text("9")
                .foregroundColor(Color.primary)
                .font(.system(size: 10))
                .offset(
                    x: round ? -(radius - 12) : -rectangelWidthPadding / 3 + 5,
                    y: round ? 0 : 14
                )
            if !round {
                Text("21")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 10))
                    .offset(
                        x: rectangelWidthPadding / 3 + 5,
                        y: 14
                    )
            }
        }
    }
}
