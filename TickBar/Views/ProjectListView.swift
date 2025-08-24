//
//  ProjectListView.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ProjectListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Project.position) private var projects: [Project]
    
    @State private var showingAddProject = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                HStack{
                    
                    CloseButton{
                        NSApp.terminate(nil)
                    }

                    
                    Text("Projects").font(.title2).bold()
                    Spacer()
                    Button{
                        showingAddProject = true
                    } label: {
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
                    ForEach(projects) { project in
                        NavigationLink(destination: TaskListView(project: project)) {
                            HStack {
                                Text(project.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    delete(project)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .onMove(perform: move)
                }

            }
        }
        .background(.blue)
        .sheet(isPresented: $showingAddProject){
            AddProjectSheet { project in
                context.insert(project)
                try? context.save()
            }
        }
    }
    private func move(from source: IndexSet, to destination: Int) {
        var projectsCopy = projects
        projectsCopy.move(fromOffsets: source, toOffset: destination)
        
        for (index, project) in projectsCopy.enumerated() {
            project.position = index
        }
        
        try? context.save()
    }

    
    private func delete(_ project: Project) {
        context.delete(project)
        try? context.save()
    }
}

#Preview {
    ProjectListView()
}
