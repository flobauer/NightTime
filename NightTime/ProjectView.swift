//
//  EverydayView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 23.11.21.
//

import SwiftData
import SwiftUI

struct ProjectView: View {
    @Binding var activeProject: Project
    @Binding var showProjectCreateModal: Bool
    @Binding var showProjectEditModal: Bool

    @State var activeStream: Stream?

    var body: some View {
        ZStack(alignment: .top) {
            Color.systemGray6
            VStack {
                StreamBar(
                    activeStream: $activeStream,
                    streams: activeProject.sortedStreams
                )
                if activeStream != nil {
                    StreamView(
                        project: activeProject,
                        stream: activeStream!
                    )
                } else {
                    StreamCreateView(
                        activeProject: activeProject,
                        activeStream: $activeStream
                    )
                }
            }
        }
        .navigationBarItems(
            leading: ProjectDropdown(
                activeProject: $activeProject,
                showProjectCreateModal: $showProjectCreateModal
            ),
            trailing: Button(action: {
                showProjectEditModal = true
            }, label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(Color.primary)
            })
        )
        .navigationBarColor(UIColor.systemGray6)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            if activeProject.sortedStreams.count > 0 {
                activeStream = activeProject.sortedStreams.first
            }
        }
    }
}

#Preview {
    // load data
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    preview.addExamples(projects)

    return NavigationStack {
        ProjectView(
            activeProject: .constant(projects.first!),
            showProjectCreateModal: .constant(false),
            showProjectEditModal: .constant(false)
        )
        .modelContainer(preview.container)
        .environmentObject(DateState())
    }
}
