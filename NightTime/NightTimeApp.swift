//
//  Todo_AppApp.swift
//  Todo App
// ca
//  Created by Florian Bauer on 02.01.24.
//

import SwiftData
import SwiftUI

@main
struct NightTimeApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            Project.self,
        ])
        let config = ModelConfiguration("NightTime", schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: Project.self, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environmentObject(DateState())
    }
}
