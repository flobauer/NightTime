//
//  ProjectSamples.swift
//  NightTime
//
//  Created by Florian Bauer on 04.01.24.
//

import Foundation

extension Project {
    static var sampleProjects: [Project] {
        var projects: [Project] = []
        
        for i in 1 ... 3 {
            let project = Project(name: "Project \(i)")
            
            // create stream
            let stream = Stream(name: "Stream 1")
            
            project.streams = [stream]
            projects.append(project)
        }
        
        return projects
    }
}
