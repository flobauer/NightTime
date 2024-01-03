//
//  Todo_AppApp.swift
//  Todo App
// ca
//  Created by Florian Bauer on 02.01.24.
//

import SwiftData
import SwiftUI

@main
struct Todo_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(DateState())
    }
}
