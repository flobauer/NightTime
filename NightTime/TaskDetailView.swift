//
//  TaskList.swift
//  Todo App
//
//  Created by Florian Bauer on 03.01.24.
//

import SwiftData
import SwiftUI

struct TaskDetailView: View {
    @Environment(\.modelContext) var modelContext
    @State var task: Task

    var body: some View {
        Text(task.title)
    }
}
