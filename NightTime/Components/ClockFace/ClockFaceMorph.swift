//
//  ClockFace.swift
//  TimeTracker
//
//  Created by Florian Bauer on 29.12.21.
//

import AVFoundation
import CoreHaptics
import SwiftUI

struct ClockFaceMorph: View {
    @Binding var round: Bool
    @State private var engine: CHHapticEngine?
    @State var lastTick: Int = 0

    //
    // START Date
    //
    @Binding var start: Date
    // START Hour in Decimal
    var startValue: CGFloat {
        let calendar = Calendar.current
        let hour: Int = calendar.component(.hour, from: start)
        let minutes: Int = calendar.component(.minute, from: start)
        return CGFloat(Double(hour) + (Double(minutes) / 60))
    }

    // START Angle for UI
    var startAngleValue: CGFloat {
        let fixedAngle = startValue * (2.0 * .pi) / config.totalValue
        return fixedAngle * 180 / .pi
    }

    //
    // END Date
    //
    @Binding var end: Date
    // END Hour in Decimal
    var endValue: CGFloat {
        let calendar = Calendar.current
        let hour: Int = calendar.component(.hour, from: end)
        let minutes: Int = calendar.component(.minute, from: end)
        return CGFloat(Double(hour) + (Double(minutes) / 60))
    }

    // END Angle for UI
    var endAngleValue: CGFloat {
        let fixedAngle = endValue * (2.0 * .pi) / config.totalValue
        return fixedAngle * 180 / .pi
    }

    // DURATION
    var duration: CGFloat {
        // calculate duration
        if endValue > startValue {
            return endValue / config.totalValue - startValue / config.totalValue
        } else {
            return (config.totalValue - startValue + endValue) / config.totalValue
        }
    }

    // DURATION in MINUTES
    var durationInMinutes: Int {
        return Int(duration * config.totalValue * 60)
    }

    var durationInHours: Int {
        return Int(duration * config.totalValue)
    }

    let config = Config(totalValue: 12,
                        knobRadius: 8.0,
                        radius: 70.0)

    var circleWidth: Double {
        return config.radius * 2.5
    }

    var body: some View {
        GeometryReader { geometry in
            let rectangleWidth = geometry.size.width
            ZStack {
                ClockFaceBackground(
                    radius: config.radius,
                    round: $round
                )
                ClockFaceLabels(
                    rectangleWidth: rectangleWidth,
                    radius: config.radius,
                    round: $round
                )
                // Area between
                if round {
                    Circle()
                        .trim(from: 0, to: duration)
                        .stroke(Color.yellow, lineWidth: 4)
                        .rotationEffect(.degrees(Double(startAngleValue) - 90))
                        .padding(config.radius * 0.64)
                } else {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: CGFloat(durationInHours * Int(rectangleWidth) / 18), height: 4)
                        .offset(x: CGFloat((startValue - 15) * rectangleWidth / 18) + CGFloat(durationInHours * Int(rectangleWidth) / 36), y: 0)
                }

                // Start Zeiger
                ClockZeiger(
                    radius: config.knobRadius,
                    color: Color.green,
                    round: $round
                )
                .offset(
                    x: round ? 0 : (startValue - 15) * rectangleWidth / 18,
                    y: round ? -(config.radius - config.radius * 0.64) : 0
                )
                .rotationEffect(Angle.degrees(round ? Double(startAngleValue) : 0))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { gesture in
                        round ?
                            change(location: gesture.location, start: true) :
                            changeRect(location: gesture.location, start: true)

                    })

                // End Zeiger
                ClockZeiger(
                    radius: config.knobRadius,
                    color: Color.yellow,
                    round: $round
                )
                .offset(
                    x: round ? 0 : (endValue - 15) * rectangleWidth / 18,
                    y: round ? -(config.radius - config.radius * 0.64) : 0
                )
                .rotationEffect(Angle.degrees(round ? Double(endAngleValue) : 0))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { gesture in
                        round ?
                            change(location: gesture.location) :
                            changeRect(location: gesture.location)
                    })

                if round {
                    ZStack {
                        Circle()
                            .fill(Color.systemBackground)
                        Circle()
                            .fill(Color.systemGray6)
                            .overlay(
                                Circle()
                                    .stroke(Color.systemBackground, lineWidth: 1)
                                    .shadow(color: Color.systemGray2, radius: 1, x: 0, y: 1)
                                    .clipShape(
                                        Circle()
                                    )
                            )

                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.primary)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .padding(config.radius * 0.9)
                }
            }
            .frame(
                width: round ? circleWidth : rectangleWidth,
                height: round ? circleWidth : circleWidth / 3
            )
            .animation(.spring(), value: round)
        }
        .onAppear(perform: prepareHaptics)
    }

    private func change(location: CGPoint, start: Bool = false) {
        // creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)

        // getting angle in radian need to subtract the knob radius and padding from the dy and dx
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi / 2.0

        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle

        // get the position of the draged zeiger
        let angleHelper = fixedAngle / (2.0 * .pi) * config.totalValue

        // calculate the hour
        let tempStunde = Int(angleHelper)

        // calculate the minutes
        let tempMinutes = Int(angleHelper * 60)
        let tempMinute = Int(tempMinutes % 60)

        if start == true {
            // create date component object
            var startTime = Calendar.current.date(bySettingHour: tempStunde, minute: tempMinute, second: 0, of: self.start)!
            // set date
            let hour = Calendar.current.component(.hour, from: self.start)

            if hour > 12 {
                startTime.addTimeInterval(12 * 60 * 60)
            }
            self.start = startTime
        } else {
            // create date component object
            var endTime = Calendar.current.date(bySettingHour: tempStunde, minute: tempMinute, second: 0, of: end)!
            // set date
            let hour = Calendar.current.component(.hour, from: self.start)
            // set date
            if endTime < self.start || hour > 12 {
                endTime.addTimeInterval(12 * 60 * 60)
            }
            end = endTime
        }

        if durationInMinutes % 5 == 0 && lastTick != durationInMinutes {
            lastTick = durationInMinutes // to avoid multiple clicking when staying on a number
            hapticFeedback()
        }
    }

    private func changeRect(location: CGPoint, start: Bool = false) {
        let position = location.x
        print(durationInMinutes)

        // get the hour of the new location

        // calculate the hour
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func hapticFeedback() {
        AudioServicesPlaySystemSound(1104)

        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct Config {
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct ClockFaceMorph_Previews: PreviewProvider {
    struct ContainerView: View {
        @State private var round: Bool = true
        @State private var start: Date = .now
        @State private var end: Date = Date.now.addingTimeInterval(7200)

        var body: some View {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ClockFaceMorph(
                        round: $round,
                        start: $start,
                        end: $end
                    )
                    Spacer()
                }
                Spacer()
                Button("Change") {
                    round.toggle()
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .preferredColorScheme(.light)
            .background(Color.systemGray6)
            .edgesIgnoringSafeArea(.all)
        }
    }

    static var previews: some View {
        ContainerView()
    }
}
