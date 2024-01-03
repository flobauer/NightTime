//
//  ContentView.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var showCreateModal: Bool
    
    var projects: [Project]
    @State var searchText = ""
    
    var searchResults: [Project] {
        if searchText.isEmpty {
            return projects
        } else {
            return projects.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(searchResults, id: \.id) { project in
                    
                }.onDelete(perform: deleteItems)
            }
            Text("We store the timetracking information in a spreadsheet that is owned by you, so that you stay in control at any time.")
                .padding()
                .fixedSize(horizontal: false, vertical: true)
        }
        .searchable(text: $searchText)
        
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(projects[index])
            }
        }
    }
}
