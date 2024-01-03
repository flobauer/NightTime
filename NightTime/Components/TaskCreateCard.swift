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
            HStack {
                NeumorphicStyleTextField(
                    textField: TextField("How you doin...", text: self.$activity),
                    focus: self.$TaskTitleIsFocused,
                    imageName: "magnifyingglass"
                )
            }
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
                            Text("Manual Entry")
                                .font(.headline)
                            Spacer()
                            Button("Back") {
                                self.showManualInputs.toggle()
                            }
                        }
                        VStack {
                            DatePicker("Start", selection: self.$start)
                            DatePicker("End", selection: self.$end)
                        }.padding(.bottom)
                    }

                    HStack {
                        if self.showManualInputs {
                            CustomButton(title: "Save") {
                                TaskTitleIsFocused = false
                                action()
                            }
                        }
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
                        CustomButton(title: "Save") {
                            TaskTitleIsFocused = false
                            action()
                        }
                        .padding(.top)
                    }

                }.padding(.leading, 10)
            }
        }
        .padding()
    }
}

struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var focus: FocusState<Bool>.Binding
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.systemGray)
            textField
        }
        .padding(10)
        .background(Color.systemGray6)
        .cornerRadius(10)
        .shadow(color: Color.systemBackground, radius: 2, x: 1, y: 1)
        .shadow(color: Color.systemGray4, radius: 1, x: -1, y: -1)
        .focused(self.focus)
    }
}
