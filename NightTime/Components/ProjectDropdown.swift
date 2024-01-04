//
//  Project.swift
//  TimeTracker
//
//  Created by Florian Bauer on 22.11.21.
//

import SwiftData
import SwiftUI

struct ProjectDropdown: View {
    @Binding var activeProject: Project
    @Binding var showProjectCreateModal: Bool

    @Query var projects: [Project]

    var body: some View {
        Menu {
            ForEach(
                self.projects, id: \.id, content: { project in
                    Button(action: {
                        self.activeProject = project

                        let lastSelectedProject = projects.first(where: { $0.selected })
                        lastSelectedProject?.selected = false

                        project.selected = true
                    }, label: {
                        Text(project.name)
                    })
                }
            )
            Button(action: {
                self.showProjectCreateModal = true
            }, label: {
                Label("Add another Project", systemImage: "plus")
            })
        } label: {
            HStack {
                Text(self.activeProject.name).foregroundColor(Color.primary)
                Image(systemName: "chevron.down").foregroundColor(Color.primary)
            }
        }
    }
}

#Preview {
    // load data
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    preview.addExamples(projects)

    return ProjectDropdown(
        activeProject: .constant(projects.first!),
        showProjectCreateModal: .constant(false)
    ).modelContainer(preview.container)
}
