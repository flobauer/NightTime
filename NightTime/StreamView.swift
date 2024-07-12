//
//  DetailCardView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 25.11.21.
//

import SwiftData
import SwiftUI

struct StreamView: View {
    @Environment(\.modelContext) var modelContext
    
    var project: Project
    var stream: Stream
    
    @State private var activity = ""
    @State private var start: Date = .now
    @State private var end: Date = .now
    
    @State private var showingHeader = true
    @State private var turningPoint = CGFloat.zero // ADDED
    let thresholdScrollDistance: CGFloat = 50 // ADDED
    
    var body: some View {
        VStack {
            if showingHeader {
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
                            start = getStartDate(tasks: stream.sortedTasks, date: Date.now)
                            end = getEndDate(date: Date.now)
                        }
                    }
                )
                .onAppear {
                    start = getStartDate(tasks: stream.sortedTasks, date: Date.now)
                    end = getEndDate(date: Date.now)
                }
            }
            GeometryReader { outer in
                let outerHeight = outer.size.height
                ScrollView(.vertical) {
                    TaskDayGroupingView(stream: stream)
                        .background {
                            GeometryReader { proxy in
                                let contentHeight = proxy.size.height
                                let minY = max(
                                    min(0, proxy.frame(in: .named("ScrollView")).minY),
                                    outerHeight - contentHeight
                                )
                                Color.clear
                                    .onChange(of: minY) { oldVal, newVal in
                                        if (showingHeader && newVal > oldVal) || (!showingHeader && newVal < oldVal) {
                                            turningPoint = newVal
                                        }
                                        if (showingHeader && (turningPoint - newVal) > thresholdScrollDistance) ||
                                            (!showingHeader && (newVal - turningPoint) > thresholdScrollDistance)
                                        {
                                            showingHeader = newVal > turningPoint
                                        }
                                    }
                            }
                        }
                }
                .coordinateSpace(name: "ScrollView")
                .padding()
                .background(Color.systemBackground)
            }
        }
        .animation(.easeInOut, value: showingHeader)
    }
}

#Preview {
    // load data
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    preview.addExamples(projects)
    
    let project = projects.first!

    return NavigationStack {
        StreamView(
            project: project,
            stream: project.streams!.first!
        )
        .modelContainer(preview.container)
        .environmentObject(DateState())
    }
}
