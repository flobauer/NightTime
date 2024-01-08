//
//  ClockFace.swift
//  TimeTracker
//
//  Created by Florian Bauer on 29.12.21.
//

import AVFoundation
import CoreHaptics
import SwiftUI

struct ClockFace: View {
    @State private var engine: CHHapticEngine?
    @State var lastTick: Int = 0

    //
    // START Date
    //
    @Binding var start: Date
    // START Hour in Decimal
    var startValue: CGFloat {
        //As mentioned in the DateHelper I would highly advise not to perform these operations inside of the view.
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

    let config = Config(totalValue: 12,
                        knobRadius: 8.0,
                        radius: 70.0)

    var width: Double {
        return config.radius * 2.5
    }

    var body: some View {
        ZStack {
            ZStack {
                Circle().fill(Color.systemBackground)
                Circle()
                    .fill(Color.systemGray6)
                    .overlay(
                        Circle()
                            .stroke(Color.systemBackground,
                                    lineWidth: 4)
                            .shadow(color: Color.systemGray2, radius: 1, x: 1, y: 1)
                            .clipShape(
                                Circle()
                            )
                    ).padding(5)
                Circle()
                    .fill(Color.systemBackground)
                    .overlay(
                        Circle()
                            .fill(Color.systemBackground)
                            .shadow(color: Color.systemGray2, radius: 1, x: 0, y: 1)
                    )
                    .padding(config.radius * 0.64)
            }

            // Seconds and Minutes
            ForEach(0 ..< 60, id: \.self) { i in
                Rectangle()
                    .fill(Color.primary.opacity((i % 5) == 0 ? 1 : 0.4))
                    .frame(width: 1, height: (i % 5) == 0 ? 12 : 8)
                    .offset(y: (i % 5) == 0 ? config.radius : config.radius)
                    .rotationEffect(.degrees(Double(i) * 6))
            }
            ZStack {
                Text("12")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 10))
                    .offset(y: -(config.radius - 12))
                Text("3").foregroundColor(Color.primary)
                    .font(.system(size: 10))
                    .offset(x: config.radius - 12)
                Text("6").foregroundColor(Color.primary)
                    .font(.system(size: 10))
                    .offset(y: config.radius - 12)
                Text("9").foregroundColor(Color.primary)
                    .font(.system(size: 10))
                    .offset(x: -(config.radius - 12))
            }

            // Area between
            Circle()
                .trim(from: 0, to: duration)
                .stroke(Color.yellow, lineWidth: 4)
                .rotationEffect(.degrees(Double(startAngleValue) - 90))
                .padding(config.radius * 0.64)

            // Start Zeiger
            ClockZeiger(radius: config.knobRadius, color: Color.green)
                .offset(y: -(config.radius - config.radius * 0.64))
                .rotationEffect(Angle.degrees(Double(startAngleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        change(location: value.location, start: true)
                    })

            // End Zeiger
            ClockZeiger(radius: config.knobRadius, color: Color.yellow)
                .offset(y: -(config.radius - config.radius * 0.64))
                .rotationEffect(Angle.degrees(Double(endAngleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        change(location: value.location)
                    })

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
        .frame(width: width, height: width)
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
        //try to stay consistent with naming usually everything should be named in english
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

struct ClockZeiger: View {
    let radius: Double
    let color: Color

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
            Rectangle()
                .fill(color)
                .frame(width: 3, height: 30)
        }
    }
}

struct Config {
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct ClockFace_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ClockFace(
                    start: .constant(Date.now),
                    end: .constant(
                        Date.now.addingTimeInterval(7200)
                    )
                )
                Spacer()
            }
            Spacer()
        }
        .preferredColorScheme(.light)
        .background(Color.systemGray6)
        .edgesIgnoringSafeArea(.all)
    }
}

//This seems out of place here I would recommend to create a seperate file for this.
extension Color {
    // MARK: - Text Colors

    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors

    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors

    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)

    // MARK: - Fill Colors

    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)

    // MARK: - Grouped Background Colors

    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)

    // MARK: - Gray Colors

    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)

    // MARK: - Other Colors

    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)

    // MARK: System Colors

    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)
}
