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
    @State private var start: Date = .now
    @State private var end: Date = .now
    
    init(stream: Stream, day: Date) {
        self.stream = stream
        self.day = day
        
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
                modelContext.delete(self.tasks[index])
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Color.systemGray6.cornerRadius(10)
                TaskCreateCard(
                    activity: self.$activity,
                    start: self.$start,
                    end: self.$end,
                    action: {
                        let task = Task(
                            title: self.activity,
                            startDate: getDateString(date: self.start),
                            startTime: getTimeString(date: self.start),
                            endDate: getDateString(date: self.end),
                            endTime: getTimeString(date: self.end),
                            user: "flo"
                        )
                        
                        self.stream.tasks?.append(task)
                        
                        self.activity = ""
                        
                        withAnimation {
                            self.start = getStartDate(tasks: self.tasks)
                            self.end = getEndDate()
                        }
                    }
                ).onAppear {
                    self.start = getStartDate(tasks: self.tasks)
                    self.end = getEndDate()
                }
            }
            if self.tasks.isEmpty {
                Text("No tasks yet")
            } else {
                List {
                    ForEach(self.tasks, id: \.id) { task in
                        HStack {
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                Text(task.title)
                            }
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
                    }.onDelete(perform: deleteItems)
                }
            }
        }.navigationTitle(getDateString(date: day))
    }
}
