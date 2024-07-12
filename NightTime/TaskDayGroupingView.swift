//
//  TaskList.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftData
import SwiftUI

struct TaskDayGroupingView: View {
    @EnvironmentObject var appState: DateState

    var stream: Stream

    var body: some View {
        LazyVStack { 
            ForEach(self.appState.allDays, id: \.id) { day in
                NavigationLink(destination: TaskListView(stream: stream, day: day.date)) {
                    DateCard(
                        date: day.day,
                        month: day.month,
                        name: day.weekday,
                        time: calculateHoursPerDay(day: day.date, tasks: self.stream.tasks)
                    ).padding(.vertical, 6)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.systemGray)
                        .font(.system(size: 24))
                }
            }
        }
        .onAppear {
            self.appState.generateDays(number: 30)
        }
    }
}
