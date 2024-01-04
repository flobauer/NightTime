//
//  CreateView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 25.11.21.
//

import SwiftUI

struct ProjectCreateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var projects: [Project]
    
    @State private var projectName = ""
    
    var text = """
    To store your timetracking we create additonal Sheets in your document to avoid interfering with you data.
    You can have multiple streams / sheets in your document to track time more granular.
    Tell us how you want to name your first project:
    """

    var body: some View {
        VStack {
            VStack {
                TextField("Project Name", text: $projectName)
                    .padding(.bottom)
                Button("Create a new Project", action: {
                    if projectName != "" {
                        // reset all selected projects
                        let selectedProject = projects.first(where: { $0.selected })
                        selectedProject?.selected = false
                        
                        // add a project
                        let project = Project(name: projectName)
                        project.selected = true
                        
                        // add the first Stream
                        let stream = Stream(name: "Stream 1")
                        stream.order = 0
                        project.streams?.append(stream)
                        
                        self.modelContext.insert(project)
                        
                        projectName = ""
                        
                        // navigate to ProjectView
                        dismiss()
                    }
                })
            }
            .padding()
            .clipped()
            .cornerRadius(15)
            .padding()
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(0.6), radius: 10, x: -5, y: -5)
            Spacer()
        }
        .padding(.top, 80)
    }
}
