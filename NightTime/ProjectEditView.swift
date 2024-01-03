//
//  CreateView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 25.11.21.
//

import SwiftUI

struct ProjectEditView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var project: Project
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Name")) {
                    TextField("Name", text: $project.name)
                }
                Section(header: Text("Streams")) {
                    ForEach(project.sortedStreams, id: \.id) { stream in
                        TextField("Stream Name", text: $project.streams[project.streams.firstIndex(of: stream)!].name)
                    }.onMove { from, to in
                        // Make a copy of the current list of items
                        var updatedItems = self.project.sortedStreams
                        
                        // Apply the move operation to the items
                        updatedItems.move(fromOffsets: from, toOffset: to)
                        updatedItems.updateOrderIndices()
                        
                    }.onDelete(perform: deleteItems)
                }
            }.toolbar {
                // 1
                EditButton()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(project.sortedStreams[index])
            }
        }
    }
}
