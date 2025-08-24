//
//  AddProjectSheet.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI

struct AddProjectSheet: View {
    @State private var name = ""
    @Environment(\.dismiss) private var dismiss
    var onComplete: (Project) -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Add Project").font(.title3).bold()
            TextField("Project name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit(done)
                .padding(.horizontal)
            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Done", action: done)
                    .keyboardShortcut(.defaultAction)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
        }
        .padding(16)
        .frame(width: 300)
    }
    
    private func done() {
        let p = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !p.isEmpty else { return }
        onComplete(Project(name: p)); dismiss()
    }
}

#Preview {
    AddProjectSheet{ project in
        
    }
}
