//
//  EditTaskSheet.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI

struct EditTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    var onSave: (String) -> Void

    init(initialTitle: String, onSave: @escaping (String) -> Void) {
        _title = State(initialValue: initialTitle)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Edit Task").font(.title3).bold()
            TextField("Task title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit(save)
                .padding(.horizontal)
            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
        }
        .padding(16)
        .frame(width: 320)
    }
    private func save() {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        onSave(t); dismiss()
    }
}
