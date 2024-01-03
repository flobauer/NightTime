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
    
    private var selectedProject: Binding<Project> {
        Binding(
            get: { (projects.first(where: { $0.selected }) ?? projects.first)! },
            set: { _ in }
        )
    }
    
    @State private var showCreateModal: Bool = false
    @State private var showEditModal: Bool = false
    
    var body: some View {
        NavigationView {
            if !projects.isEmpty {
                ProjectView(activeProject: selectedProject, showCreateModal: $showCreateModal, showEditModal: $showEditModal)
            } else {
                VStack {
                    Text("Night Time").font(.largeTitle).padding()
                    Text("Timetracking for humans in the creative industry that dislike time tracking").font(.title2).padding()
                    Button(action: {
                        self.showCreateModal = true
                    }) {
                        Label("Create Project", systemImage: "plus")
                    }
                }
            }
        }.sheet(isPresented: $showCreateModal) {
            ProjectCreateView(projects: projects)
        }.sheet(isPresented: $showEditModal) {
            ProjectEditView(project: selectedProject)
        }
    }
}
