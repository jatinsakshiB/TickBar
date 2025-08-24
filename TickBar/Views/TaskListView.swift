//
//  TaskListView.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct TaskListView: View {
    @Query private var tasks: [Task]
    let project: Project

    @Environment(\.modelContext) private var context

    @Environment(\.dismiss) private var dismiss

    @State private var taskToEdit: Task? = nil
    
    init(project: Project) {
        self.project = project
        let id = project.persistentModelID
        let predicate = #Predicate<Task> { task in
            task.project?.persistentModelID == id
        }
        _tasks = Query(filter: predicate, sort: [SortDescriptor(\.position)])
    }


    var body: some View {
        NavigationStack(){
            VStack(spacing: 0){
                HStack(spacing: 12) {
                    // Back button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2) // match title size
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    // Title
                    Text(project.name)
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] } // align text with icon

                    Spacer()
                    
                    Button{
                        for task in tasks{
                            context.delete(task)
                        }
                        try? context.save()
                    } label: {
                        Image(systemName: "trash")
                            .padding(6)
                            .background(Circle().fill(Color.red))
                    }
                    .buttonStyle(.plain)
                    
                    // Add button
                    NavigationLink(destination: AddTaskView(project: project)){
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .padding(6)
                            .background(Circle().fill(Color.white))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)

                List {
                    ForEach(tasks) { task in
                        HStack {
                            Toggle(task.title, isOn: Binding(
                                get: { task.isDone },
                                set: { newValue in
                                    task.isDone = newValue
                                    try? context.save()  // save changes
                                }
                            ))
                                .toggleStyle(.checkbox)
                                .labelsHidden()
                            Text(task.title)
                                .strikethrough(task.isDone, color: .gray)
                                .foregroundColor(task.isDone ? .secondary : .primary)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button {
                                taskToEdit = task
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                delete(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove(perform: move)
                }


            }
        }
        .background(.blue)
        .sheet(item: $taskToEdit) { task in
            EditTaskSheet(initialTitle: task.title) { newTitle in
                task.title = newTitle
                try? context.save()
                taskToEdit = nil
            }
        }
        
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        var tasksCopy = tasks
        tasksCopy.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in tasksCopy.enumerated() {
            task.position = index
        }
        try? context.save()
    }

    
    private func delete(_ task: Task) {
        context.delete(task)
        try? context.save()
    }

}

#Preview {
    TaskListView(project: Project(name: "Jatin"))
}


