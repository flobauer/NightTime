//
//  Task.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import Foundation
import SwiftData

@Model
final class Task {
    @Attribute(.unique) var id: String
    var title: String
    var startDate: String
    var startTime: String
    var endDate: String
    var endTime: String
    var user: String
    var lastUpdatedAt: Date
    
    var stream: Stream?
    
    init(title: String, startDate: String, startTime: String, endDate: String, endTime: String, user: String) {
        self.id = UUID().uuidString
        self.title = title
        self.startDate = startDate
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
        self.user = user
        self.lastUpdatedAt = Date.now
    }
    
    func getStartAsDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d. MMMM yyyy H:mm:ss zzzz"
        
        // concat time and date
        let start = "\(self.startDate) \(self.startTime)"
        
        return formatter.date(from: start) ?? Date.now
    }
    
    func getEndAsDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d. MMMM yyyy H:mm:ss zzzz"
        
        // concat time and date
        let end = "\(self.endDate) \(self.endTime)"
        
        return formatter.date(from: end) ?? Date.now
    }
}
