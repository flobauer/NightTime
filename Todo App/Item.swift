//
//  Item.swift
//  Todo App
//
//  Created by Florian Bauer on 02.01.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
