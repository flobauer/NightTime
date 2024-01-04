//
//  SheetBar.swift
//  TimeTracker
//
//  Created by Florian Bauer on 29.12.21.
//

import SwiftUI

struct StreamBar: View {
    @Binding var activeStream: Stream?
    @Namespace var namespace

    var streams: [Stream]

    var currentIndex: Int {
        if activeStream === nil {
            return streams.count
        }

        return streams.firstIndex(of: activeStream!) ?? streams.count
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(
                    Array(
                        zip(
                            self.streams.indices, self.streams
                        )
                    ), id: \.0, content: { index, stream in
                        StreamBarItem(
                            currentIndex: currentIndex,
                            namespace: namespace,
                            title: stream.name,
                            tab: index,
                            action: {
                                self.activeStream = stream
                            }
                        )
                    }
                )
                StreamBarItem(
                    currentIndex: currentIndex,
                    namespace: namespace,
                    title: "+",
                    tab: self.streams.count,
                    action: {
                        self.activeStream = nil
                    }
                )
            }
            .background(Color.systemBackground)
            .cornerRadius(10)
            .padding()
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}
