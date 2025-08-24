//
//  AddTaskSheet.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI

struct AddTaskView: View {
    var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var newTasks: [String] = [""]
    @FocusState private var focusedIndex: Int?

    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text("Add New Task")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 8)

            ScrollViewReader { proxy in
                List {
                    ForEach(newTasks.indices, id: \.self) { index in
                        TextField("Task \(index + 1)", text: $newTasks[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($focusedIndex, equals: index)
                            .id(index)
                            .listRowInsets(EdgeInsets()) // optional, remove extra padding
                            .padding()
                    }
                }
                .listStyle(.plain) // cleaner look
                .onChange(of: newTasks.count) { _, _ in
                    if let last = newTasks.indices.last {
                        withAnimation {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                        focusedIndex = last
                    }
                }
            }


            // Bottom buttons
            HStack {
                Button {
                    newTasks.append("")
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .padding(6)
                        .background(Circle().fill(Color.white))
                }
                .buttonStyle(.plain)
                .help("Add another task")

                Spacer()

                Button("Cancel") {
                    dismiss()
                }

                Button("Done") {
                    for title in newTasks where !title.trimmingCharacters(in: .whitespaces).isEmpty {
                        let task = Task(title: title)
                        project.tasks.append(task)
                        context.insert(task)
                    }
                    try? context.save()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
            .background(Color(.controlBackgroundColor))
        }
    }
}


