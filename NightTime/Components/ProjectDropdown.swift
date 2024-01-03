//
//  Project.swift
//  TimeTracker
//
//  Created by Florian Bauer on 22.11.21.
//

import SwiftUI
import SwiftData

struct ProjectDropdown: View {
    
    @Binding var activeProject: Project
    @Query var projects: [Project]
    @Binding var showCreateModal: Bool

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
                self.showCreateModal = true
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

