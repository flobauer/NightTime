//
//  CreateView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 25.11.21.
//

import SwiftUI

struct StreamCreateView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var activeProject: Project

    @State private var streamName = ""

    var text = """
    To store your timetracking we create additonal Sheets in your document to avoid interfering with you data.
    You can have multiple streams / sheets in your document to track time more granular.
    Tell us how you want to name your first project:
    """

    var body: some View {
        LazyVStack {
            TextField("Neuen Stream anlegen...", text: $streamName)
                .padding(.bottom)
            Button("Hinzufügen", action: {
                if streamName != "" {
                    let stream = Stream(name: streamName)
                    stream.order = self.activeProject.streams.count

                    self.activeProject.streams.append(stream)
                    streamName = ""
                }
            })
        }
        .padding()
        .clipped()
        .cornerRadius(15)
        .padding(.top, 80)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: Color.white.opacity(0.6), radius: 10, x: -5, y: -5)
        Spacer()
    }
}
