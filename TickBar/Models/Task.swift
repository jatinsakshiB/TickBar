//
//  Task.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//
import SwiftData
import Foundation

import SwiftData

@Model
final class Task {
    var id: UUID
    var title: String
    var isDone: Bool
    var position: Int

    // back reference to Project
    var project: Project?

    init(id: UUID = UUID(), title: String, isDone: Bool = false, project: Project? = nil, position: Int = 0) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.project = project
        self.position = position
    }
}

