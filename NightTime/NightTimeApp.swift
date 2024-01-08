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
    //I would do this in a seperate function in this case it is managable but if you need to configure more this becomes a bit difficult to maintain. I would create a seperate file where I initialize all my services and then use it here.
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
