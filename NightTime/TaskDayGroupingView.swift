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
        
    @Binding var stream: Stream
    
    @Query var tasks: [Task]
    
    init(stream: Binding<Stream>) {
        self._stream = stream
        
        let id = stream.id
        let predicate = #Predicate<Task> { task in
            task.stream?.id == id
        }

        self._tasks = Query(filter: predicate, sort: \Task.endDate)
    }
    
    var body: some View {
        LazyVStack {
            ForEach(self.appState.allDays, id: \.id) { day in
                NavigationLink(destination: TaskListView(stream: stream, day: day.date)) {
                    DateCard(
                        date: day.day,
                        month: day.month,
                        name: day.weekday,
                        time: calculateHoursPerDay(day: day.date, tasks: self.tasks)
                    ).padding(.vertical, 6)
                    Spacer()
                }
            }
        }
        .onAppear {
            self.appState.generateDays(number: 30)
        }
    }
}
