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
    
    @Binding var project: Project
    @Binding var stream: Stream
    
    @State private var activity = ""
    @State private var start: Date = .now
    @State private var end: Date = .now
    
    @State private var showingHeader = true
    @State private var turningPoint = CGFloat.zero // ADDED
    let thresholdScrollDistance: CGFloat = 50 // ADDED
    
    var body: some View {
        VStack {
            if self.showingHeader {
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
                        
                        self.stream.tasks.append(task)
                        
                        self.activity = ""
                        
                        withAnimation {
                            self.start = getStartDate(tasks: self.stream.sortedTasks)
                            self.end = getEndDate()
                        }
                    }
                )
                .onAppear {
                    self.start = getStartDate(tasks: self.stream.sortedTasks)
                    self.end = getEndDate()
                }
            }
            GeometryReader { outer in
                let outerHeight = outer.size.height
                ScrollView(.vertical) {
                    TaskDayGroupingView(stream: self.$stream)
                        .background {
                            GeometryReader { proxy in
                                let contentHeight = proxy.size.height
                                let minY = max(
                                    min(0, proxy.frame(in: .named("ScrollView")).minY),
                                    outerHeight - contentHeight
                                )
                                Color.clear
                                    .onChange(of: minY) { oldVal, newVal in
                                        if (self.showingHeader && newVal > oldVal) || (!self.showingHeader && newVal < oldVal) {
                                            self.turningPoint = newVal
                                        }
                                        if (self.showingHeader && (self.turningPoint - newVal) > self.thresholdScrollDistance) ||
                                            (!self.showingHeader && (newVal - self.turningPoint) > self.thresholdScrollDistance)
                                        {
                                            self.showingHeader = newVal > self.turningPoint
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
        .animation(.easeInOut, value: self.showingHeader)
    }
}
