//
//  CreateView.swift
//  TimeTracker
//
//  Created by Florian Bauer on 25.11.21.
//

import SwiftData
import SwiftUI

struct StreamCreateView: View {
    @Environment(\.modelContext) var modelContext

    var activeProject: Project
    @Binding var activeStream: Stream?

    @State var streamName = ""
    @FocusState var isFocused: Bool

    var text = """
    To store your timetracking we create additonal Sheets in your document to avoid interfering with you data.
    You can have multiple streams / sheets in your document to track time more granular.
    Tell us how you want to name your first project:
    """

    var body: some View {
        VStack {
            CustomTextField(
                textField: TextField("Enter Stream Name...", text: $streamName),
                focus: $isFocused,
                imageName: "water.waves"
            ).padding(.bottom)

            Button("Save", action: {
                if streamName != "" {
                    let highestOrder = self.activeProject.highestOrder

                    let stream = Stream(name: streamName)
                    stream.order = highestOrder + 1

                    self.activeProject.streams?.append(stream)
                    self.activeStream = stream

                    streamName = ""
                }
            }).disabled(streamName.isEmpty)
        }
        .padding()
        .clipped()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: Color.white.opacity(0.6), radius: 10, x: -5, y: -5)
        .onAppear {
            self.isFocused = true
        }
        Spacer()
    }
}
