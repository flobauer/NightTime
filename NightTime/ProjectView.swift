//
//  EverydayView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 23.11.21.
//

import SwiftData
import SwiftUI

struct ProjectView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeProject: Project
    @Binding var showCreateModal: Bool
    @Binding var showEditModal: Bool
    
    @Query var streams: [Stream]
    
    @State var activeStream: Stream
    @State var currentStreamIndex: Int = 0
    @State var showCreateScreen: Bool = false
    
    init(activeProject: Binding<Project>, showCreateModal: Binding<Bool>, showEditModal: Binding<Bool>) {
        print("Project Selected")
        self._activeProject = activeProject
        self._activeStream = State(initialValue: activeProject.wrappedValue.streams.first!)
        self._showCreateModal = showCreateModal
        self._showEditModal = showEditModal
        
        let id = activeProject.id
        let predicate = #Predicate<Stream> { stream in
            stream.project?.id == id
        }

        self._streams = Query(filter: predicate, sort: \Stream.order)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.systemGray6
            VStack {
                StreamBar(
                    activeStream: self.$activeStream,
                    showCreateScreen: self.$showCreateScreen,
                    streams: self.streams
                )
                StreamView(
                    project: self.$activeProject,
                    stream: self.$activeStream
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(
            leading: ProjectDropdown(
                activeProject: self.$activeProject,
                showCreateModal: self.$showCreateModal
            ),
            trailing: Button(action: {
                self.showEditModal = true
            }, label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(Color.primary)
            })
        )
        .navigationBarColor(UIColor.systemGray6)
        .sheet(isPresented: self.$showCreateScreen) {
            StreamCreateView(activeProject: self.$activeProject)
        }
        .ignoresSafeArea(.all, edges: .bottom)
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
