//
//  Spreadsheet.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import Foundation
import SwiftData

@Model
final class Stream {
    @Attribute(.unique) var id: String
    var name: String
    var timestamp: Date
    var project: Project?
    
    @Relationship(deleteRule: .cascade, inverse: \Task.stream)
    var tasks = [Task]()
    
    var sortedTasks: [Task] {
        return tasks.sorted { $0.endDate + $0.endTime < $1.endDate + $1.endTime }
    }
    
    var order: Int?
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.timestamp = Date()
    }
}
