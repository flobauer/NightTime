//
//  ContentView.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var projects: [Project]

    var selectedProject: Binding<Project> {
        Binding(
            get: { (projects.first(where: { $0.selected }) ?? projects.first)! },
            set: { _ in }
        )
    }

    @State var showProjectCreateModal: Bool = false
    @State var showProjectEditModal: Bool = false

    var body: some View {
        NavigationView {
            if !projects.isEmpty {
                ProjectView(
                    activeProject: selectedProject,
                    showProjectCreateModal: $showProjectCreateModal,
                    showProjectEditModal: $showProjectEditModal
                )
            } else {
                VStack {
                    Text("Night Time").font(.largeTitle).padding()
                    Text("Timetracking for humans in the creative industry that dislike time tracking").font(.title2).padding()
                    Button(action: {
                        showProjectCreateModal = true
                    }) {
                        Label("Create Project", systemImage: "plus")
                    }
                }
            }
        }.sheet(isPresented: $showProjectCreateModal) {
            ProjectCreateView(projects: projects)
        }.sheet(isPresented: $showProjectEditModal) {
            ProjectEditView(project: selectedProject)
        }
    }
}

#Preview {
    // load data
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    preview.addExamples(projects)

    return ContentView()
        .modelContainer(preview.container)
        .environmentObject(DateState())
}
