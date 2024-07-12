//
//  TaskList.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftData
import SwiftUI

struct TaskListView: View {
    @Environment(\.modelContext) var modelContext
    var stream: Stream
    var day: Date
    
    @Query var tasks: [Task]
    
    @State private var activity = ""
    @State private var start: Date
    @State private var end: Date
    
    init(stream: Stream, day: Date) {
        self.stream = stream
        self.day = day
        self.start = day
        self.end = day
        
        let id = stream.id
        let dateString = getDateString(date: day)
        
        let predicate = #Predicate<Task> { task in
            task.stream?.id == id && task.endDate == dateString
        }

        self._tasks = Query(filter: predicate, sort: \Task.endTime)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Color.systemGray6.cornerRadius(10)
                TaskEditCard(
                    activity: $activity,
                    start: $start,
                    end: $end,
                    action: {
                        let task = Task(
                            title: activity,
                            startDate: getDateString(date: start),
                            startTime: getTimeString(date: start),
                            endDate: getDateString(date: end),
                            endTime: getTimeString(date: end),
                            user: "flo"
                        )
                        
                        stream.tasks?.append(task)
                        
                        activity = ""
                        
                        withAnimation {
                            start = getStartDate(tasks: tasks, date: day)
                            end = getEndDate(date: day)
                        }
                    }
                ).onAppear {
                    start = getStartDate(tasks: tasks, date: day)
                    end = getEndDate(date: day)
                }
            }
            if tasks.isEmpty {
                Text("No tasks yet")
            } else {
                List {
                    ForEach(tasks, id: \.id) { task in
                        HStack {
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                Text(task.title)
                                Spacer()
                                VStack {
                                    Text(calculateHoursOfTask(start: task.getStartAsDate(), end: task.getEndAsDate()))
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                    Text(task.startDate)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }.onDelete(perform: deleteItems)
                }
            }
        }.navigationTitle(getDateString(date: day))
    }
}
