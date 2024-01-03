//
//  Project.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import Foundation
import SwiftData

@Model
final class Project {
    @Attribute(.unique) var id: Int
    var name: String
    var timestamp: Date
    var selected: Bool

    @Relationship(deleteRule: .cascade, inverse: \Stream.project)
    var streams = [Stream]()

    var sortedStreams: [Stream] {
        return streams.sorted { $0.order! < $1.order! }
    }

    init(name: String) {
        self.id = UUID().hashValue
        self.name = name
        self.timestamp = Date()
        self.selected = false
    }
}

extension [Stream] {
    func updateOrderIndices() {
        for (index, item) in enumerated() {
            item.order = index
        }
    }
}
