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
                    ForEach(project.sortedStreams) { stream in
                        EditScreenName(stream: stream)
                    }.onMove { from, to in
                        // Make a copy of the current list of items
                        var updatedItems = project.sortedStreams
                        
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

struct EditScreenName: View {
    var stream: Stream
    @State var name: String = ""
    
    var body: some View {
        TextField("Stream Name", text: $name)
            .onAppear {
                name = stream.name
            }
            .onChange(of: name) { _, newValue in
                stream.name = newValue
            }
    }
}
