//
//  PreviewContainer.swift
//  NightTime
//
//  Created by Florian Bauer on 04.01.24.
//

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create Preview Container: \(error)")
        }
    }

    func addExamples(_ examples: [any PersistentModel]) {
        _Concurrency.Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
