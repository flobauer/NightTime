//
//  AddTaskCard.swift
//  TimeTracker
//
//  Created by Florian Bauer on 30.12.21.
//

import SwiftUI

struct TaskCreateCard: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var activity: String
    @Binding var start: Date
    @Binding var end: Date

    @State var showManualInputs: Bool = false

    @FocusState private var TaskTitleIsFocused: Bool

    let action: () -> Void

    var body: some View {
        VStack {
            CustomTextField(
                textField: TextField("Enter your activity...", text: self.$activity),
                focus: self.$TaskTitleIsFocused,
                imageName: "clock.circle.fill"
            ).padding(.bottom)
            HStack {
                if self.showManualInputs == false {
                    ClockFace(start: self.$start, end: self.$end)
                }
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
                                }
                            }
                        }
                    } else {
                        HStack {
                            Button("Close") {
                                withAnimation {
                                    self.showManualInputs.toggle()
                                }
                            }
                            Spacer()
                        }
                        VStack {
                            DatePicker("Start", selection: self.$start)
                            DatePicker("End", selection: self.$end)
                        }.padding(.bottom)
                    }

                    HStack(alignment: .bottom) {
                        CustomButton(title: "Save") {
                            TaskTitleIsFocused = false
                            action()
                        }.disabled(self.activity == "")
                        Spacer()
                        Text(hourString(start: self.start, end: self.end))
                            .font(.title)
                            .bold()
                            .padding(.top)
                    }
                    if self.showManualInputs == false {
                        HStack {
                            Spacer()
                            Text(timeString(start: self.start, end: self.end)).font(.caption)
                        }
                    }

                }.padding(.leading, 10)
            }
        }
        .padding()
    }
}

#Preview {
    TaskCreateCard(
        activity: .constant(""),
        start: .constant(.now),
        end: .constant(.now),
        action: {}
    )
}
