//
//  Project.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//
import Foundation
import SwiftData

@Model
final class Project {
    var id: UUID
    var name: String
    var position: Int   // 👈 order field

    // relationship → one project has many tasks
    @Relationship(deleteRule: .cascade) var tasks: [Task] = []

    init(id: UUID = UUID(), name: String, position: Int = 0) {
        self.id = id
        self.name = name
        self.position = position
    }
}
