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
                    activeStream: self.$activeStream,
                    streams: self.activeProject.sortedStreams
                )
                if self.activeStream != nil {
                    StreamView(
                        project: self.activeProject,
                        stream: self.activeStream!
                    )
                } else {
                    StreamCreateView(
                        activeProject: self.activeProject,
                        activeStream: self.$activeStream
                    )
                }
            }
        }
        .navigationBarItems(
            leading: ProjectDropdown(
                activeProject: self.$activeProject,
                showProjectCreateModal: self.$showProjectCreateModal
            ),
            trailing: Button(action: {
                self.showProjectEditModal = true
            }, label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(Color.primary)
            })
        )
        .navigationBarColor(UIColor.systemGray6)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            if self.activeProject.sortedStreams.count > 0 {
                self.activeStream = self.activeProject.sortedStreams.first
            }
        }
    }
}

extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

extension View {
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor?
    
    //I would not set appearances in here usually you set these on AppStart this would be a great thing to do in a SetupServices Class
    init(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor

        let textColor = UIColor(Color.primary)

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = textColor
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
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
