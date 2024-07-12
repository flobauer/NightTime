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

struct ClockFaceBackground: View {
    let radius: CGFloat
    @Binding var round: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: round ? radius * 2 : 0)
                .fill(Color.systemBackground)

            RoundedRectangle(cornerRadius: round ? radius * 2 : 0)
                .fill(Color.systemGray6)
                .overlay(
                    RoundedRectangle(cornerRadius: round ? radius * 2 : 0)
                        .stroke(Color.systemBackground,
                                lineWidth: 4)
                        .shadow(color: Color.systemGray2, radius: 1, x: 1, y: 1)
                        .clipShape(
                            RoundedRectangle(cornerRadius: round ? radius * 2 : 0)
                        )
                        .cornerRadius(round ? radius * 2 : 0)
                ).padding(5)

            if round {
                Circle()
                    .fill(Color.systemBackground)
                    .overlay(
                        Circle()
                            .fill(Color.systemBackground)
                            .cornerRadius(round ? radius * 2 : 0)
                            .shadow(
                                color: Color.systemGray2,
                                radius: 1,
                                x: 0,
                                y: 1
                            )
                    )
                    .padding(radius * 0.64)
            }
        }
    }
}

struct ClockFaceBackground_Previews: PreviewProvider {
    static var previews: some View {
        ClockFaceBackground(
            radius: 70,
            round: .constant(true)
        ).frame(
            width: 200,
            height: 200
        )
    }
}
