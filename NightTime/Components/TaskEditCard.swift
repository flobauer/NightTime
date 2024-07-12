//
//  AddTaskCard.swift
//  TimeTracker
//
//  Created by Florian Bauer on 30.12.21.
//

import SwiftUI

struct TaskEditCard: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var activity: String
    @Binding var start: Date
    @Binding var end: Date

    @State var showManualInputs: Bool = false
    @State var round: Bool = true

    @FocusState private var TaskTitleIsFocused: Bool

    let action: () -> Void

    var body: some View {
        let layout = round ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

        VStack {
            CustomTextField(
                textField: TextField("Enter your activity...", text: $activity),
                focus: $TaskTitleIsFocused,
                imageName: "clock.circle.fill"
            ).padding(.bottom, !showManualInputs ? 10 : 0)

            layout {
                ClockFaceMorph(
                    round: $round,
                    start: $start,
                    end: $end
                )

                VStack(alignment: .leading) {
                    if !showManualInputs {
                        HStack {
                            CustomButton(title: "Morning") {
                                withAnimation {
                                    start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                                    end = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
                                }
                            }
                            CustomButton(title: "Afternoon") {
                                withAnimation {
                                    start = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
                                    end = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
                                }
                            }
                        }
                        HStack {
                            CustomButton(title: "All Day") {
                                withAnimation {
                                    start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                                    end = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
                                }
                            }
                            CustomButton(title: "Manual") {
                                withAnimation {
                                    showManualInputs.toggle()
                                    round.toggle()
                                }
                            }
                        }
                    } else {
                        VStack {
                            DatePicker("Start", selection: $start)
                            DatePicker("End", selection: $end)
                        }
                    }

                    HStack(alignment: .bottom) {
                        Spacer()
                        Text(hourString(start: start, end: end))
                            .font(.title)
                            .bold()
                    }
                    if !showManualInputs {
                        HStack {
                            Spacer()
                            Text(
                                timeString(
                                    start: start,
                                    end: end
                                )
                            ).font(.caption)
                        }
                    }
                    let title = (activity.isEmpty && showManualInputs) ?
                        "Cancel" :
                        activity.isEmpty ? "Enter Activity first" : "Save"
                    CustomButton(title: title) {
                        round = true
                        showManualInputs = false

                        if !activity.isEmpty {
                            TaskTitleIsFocused = false
                            action()
                        }
                    }

                }.padding(.leading, 10)
            }
        }
        .padding()
    }
}

#Preview {
    TaskEditCard(
        activity: .constant(""),
        start: .constant(.now),
        end: .constant(.now),
        action: {}
    )
}
