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
                textField: TextField("Enter your activity...", text: self.$activity),
                focus: self.$TaskTitleIsFocused,
                imageName: "clock.circle.fill"
            ).padding(.bottom, !showManualInputs ? 10 : 0)

            layout {
                ClockFaceMorph(
                    round: self.$round,
                    start: self.$start,
                    end: self.$end
                )

                VStack(alignment: .leading) {
                    if self.showManualInputs == false {
                        HStack {
                            CustomButton(title: "Morning") {
                                withAnimation {
                                    self.start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                                    self.end = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
                                }
                            }
                            CustomButton(title: "Afternoon") {
                                withAnimation {
                                    self.start = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
                                    self.end = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
                                }
                            }
                        }
                        HStack {
                            CustomButton(title: "All Day") {
                                withAnimation {
                                    self.start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                                    self.end = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
                                }
                            }
                            CustomButton(title: "Manual") {
                                withAnimation {
                                    self.showManualInputs.toggle()
                                    self.round.toggle()
                                }
                            }
                        }
                    } else {
                        VStack {
                            DatePicker("Start", selection: self.$start)
                            DatePicker("End", selection: self.$end)
                        }
                    }

                    HStack(alignment: .bottom) {
                        Spacer()
                        Text(hourString(start: self.start, end: self.end))
                            .font(.title)
                            .bold()
                    }
                    if self.showManualInputs == false {
                        HStack {
                            Spacer()
                            Text(timeString(start: self.start, end: self.end)).font(.caption)
                        }
                    }
                    let title = (self.activity == "" && showManualInputs) ?
                        "Cancel" :
                        self.activity == "" ? "Enter Activity first" : "Save"
                    CustomButton(title: title) {
                        self.round = true
                        self.showManualInputs = false

                        if self.activity != "" {
                            self.TaskTitleIsFocused = false
                            self.action()
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
